class TimelineFetcher
  attr_reader :credential, :client, :results

  def initialize(credential)
    @credential = credential
    @client     = credential.rest_client
  end

  def perform
    @results    = []
    client.home_timeline(timeline_options).each do |native|
      tweet = credential.tweets.from_native_tweet(native)
      @last ||= tweet
      @results << tweet
    end
    credential.update(last_tweet_id: @last.tweet_id) if @last
    self
  end

  def timeline_options
    {count: 200}.tap do |o|
      o[:since_id] = credential.last_tweet_id if credential.last_tweet_id?
    end
  end
end
