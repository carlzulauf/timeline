class TimelineWatcher::Job < Struct.new(:worker, :credential)
  delegate :watcher, :redis, to: :worker
  delegate :logger, to: :watcher

  def perform
    fetch_latest_tweets
    loop do
      stream_tweets(timeout: 15.minutes)
      break if stale?
    end
  end

  def stale?
    last_stream = Time.at(redis.zscore :users, credential.user.id)
  end

  def fetch_latest_tweets
    logger.info "Fetching latest tweets for #{nickname}"
    TimelineFetcher.new(credential).perform
  end

  def stream_tweets(timeout: )
    logger.info "Streaming tweets for #{nickname}"
    TimelineStreamer.new(credential).perform_with_timeout(timeout)
  end

  def nickname
    credential.twitter_nickname
  end

  def redis
    TimelineWatcher.redis
  end
end
