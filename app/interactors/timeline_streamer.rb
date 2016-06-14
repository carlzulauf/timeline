class TimelineStreamer
  attr_reader :credential, :client, :thread

  def initialize(credential)
    @credential = credential
    @client     = credential.streaming_client
  end

  def perform
    client.user do |update|
      case update
      when Twitter::Tweet
        tweet = credential.tweet_from_native_if_unique(update)
        yield tweet if block_given? && tweet
      end
    end
  end

  def perform_with_timeout(seconds = 10, &block)
    begin
      Timeout.timeout(seconds) { perform(&block) }
    rescue Timeout::Error
      self
    end
  end

  def perform_in_background(&block)
    @thread = Thread.new { perform(&block) }
    self
  end
end
