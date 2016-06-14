class TimelineWatcher
  cattr_accessor(:redis_config) { ActionCable.server.config.cable }
  cattr_accessor(:namespace) { :timeline_watcher }
  cattr_accessor(:redis) do
    Redis::Namespace.new(namespace, url: redis_config[:url])
  end

  attr_accessor :options, :logger, :pool

  def initialize(**options)
    @options = options
    @logger = options.fetch(:logger) { Rails.logger }
    @pool = {}
  end

  def perform
    logger.info "Starting timeline watcher"
    prune_stale_users
    watch_users
    self
  end

  def perform_in_foreground
    puts "Starting TimelineWatcher..."
    perform_in_background
    logger.info "Moving background watcher to foreground"

    logger.info "Joining on watcher thread"
    @watcher_thread.join

    logger.info "Joining on listener thread"
    @listener_thread.join

    self
  end

  def perform_in_background
    logger.info "Starting timeline watcher in background"
    @watcher_thread = Thread.new do
      loop do
        prune_stale_users
        watch_users
        sleep 1.hour
      end
    end
    @listener_thread = Thread.new { listen_for_users }
    self
  end

  def listen_for_users
    redis.subscribe(:stream_users) do |on|
      on.message do |ch, user_id|
        action, user_id = ActiveSupport::JSON.decode(message)
        User.find(user_id).credentials.each {|c| watch_credential c }
      end
    end
  end

  def stop
    pool.each {|_,worker| worker.stop }
    pool.clear
    self
  end

  def prune_stale_users
    count = redis.zremrangebyscore :users, 0, 2.hours.ago.to_f
    logger.info "Pruned #{count} stale users"

    user_ids = watched_user_ids

    if user_ids.any?
      credential_ids = Authorization.where(user_id: user_ids).pluck(:credential_id).to_set
      pool.delete_if do |key, worker|
        if !worker.running?
          true
        elsif !credential_ids.member?(key)
          worker.stop
          true
        end
      end
    end
  end

  def watched_user_ids
    redis.zrevrange(:users, 0, -1)
  end

  def watch_users
    user_ids = watched_user_ids
    logger.info "Watching users: #{user_ids.join(', ')}"
    User.where(id: user_ids).each do |user|
      user.credentials.each {|c| watch_credential c }
    end
  end

  def watch_credential(c)
    unless pool[c.id]
      logger.info "Adding worker to pool for #{c.twitter_nickname}"
      pool[c.id] = TimelineWatcher::Worker.new(self, c).perform
    end
  end

  def redis
    self.class.redis
  end
end
