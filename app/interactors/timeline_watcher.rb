class TimelineWatcher
  cattr_accessor(:redis_config) { ActionCable.server.config.cable }
  cattr_accessor(:namespace) { :timeline_watcher }
  cattr_accessor(:redis) do
    Redis::Namespace.new(namespace, url: redis_config[:url])
  end

  attr_accessor :logger, :pool, :thread

  def initialize
    @logger = Logger.new("log/watcher.log")
    @pool = {}
  end

  def perform
    logger.info "Starting timeline watcher"
    prune_stale_users
    watch_users
    self
  end

  def stop
    pool.each {|_,worker| worker.stop }
    pool.clear
    self
  end

  def watched_user_ids
    redis.zrevrange(:users, 0, -1)
  end

  def prune_stale_users
    count = redis.zremrangebyscore :users, 0, 2.hours.ago.to_f
    logger.info "Pruned #{count} stale users"

    user_ids = watched_user_ids

    if user_ids.any?
      credential_ids = Authorization.where(user_id: user_ids).pluck(:credential_id).to_set
      pool.delete_if do |key, worker|
        unless credential_ids.member?(key)
          worker.stop
          true
        end
      end
    end
  end

  def watch_users
    user_ids = watched_user_ids
    logger.info "Watching users: #{user_ids.join(', ')}"
    User.where(id: user_ids).each do |user|
      user.credentials.each do |credential|
        unless pool[credential.id]
          logger.info "Adding worker to pool for #{credential.twitter_nickname}"
          pool[credential.id] = TimelineWatcher::Worker.new(self, credential).perform
        end
      end
    end
  end

  def redis
    self.class.redis
  end
end
