class TimelineWatcher::Job < Struct.new(:worker, :credential)
  delegate :watcher, :redis, to: :worker
  delegate :logger, to: :watcher

  def perform
    fetch_latest_tweets
    broadcast_latest_tweets
    loop do
      stream_tweets(timeout: 15.minutes)
      break if stale?
    end
  end

  def stale?
    last_stream_at = redis.zscore :users, credential.user.id
    return true if last_stream_at.nil?
    Time.now.to_f - last_stream_at > 2.hours
  end

  def fetch_latest_tweets
    logger.info "Fetching latest tweets for #{nickname}"
    TimelineFetcher.new(credential).perform
  end

  def broadcast_latest_tweets
    credential.tweets.latest(20).each {|t| broadcast(t) }
  end

  def stream_tweets(timeout: )
    logger.info "Streaming tweets for #{nickname}"
    TimelineStreamer.new(credential).perform_with_timeout(timeout) do |tweet|
      logger.info "Received tweet for #{nickname} via streaming: #{tweet.tweet_id}"
      broadcast(tweet)
    end
  end

  def broadcast(tweet)
    ActionCable.server.broadcast "tweets:#{tweet.credential_id}", tweet
  end

  def nickname
    credential.twitter_nickname
  end

  def redis
    TimelineWatcher.redis
  end
end
