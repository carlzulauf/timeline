class TimelineFetcher
  attr_reader :credential, :client, :results

  def initialize(credential)
    @credential = credential
    @client     = credential.rest_client
  end

  def perform
    @results  = []
    timeline  = client.home_timeline(timeline_options)
    missing   = credential.tweets.missing_tweet_ids(timeline.map(&:id))
    timeline.each do |native|
      if missing.member?(native.id)
        tweet = credential.tweet_from_native(native)
        @last ||= tweet
        @results << tweet
      end
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
