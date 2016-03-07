require 'test_helper'

class TimelineFetcherTest < ActiveSupport::TestCase
  test "updates credential.last_tweet_id" do
    refute credential.last_tweet_id
    VCR.use_cassette(:existensil_timeline) { assert fetcher.perform }
    assert credential.last_tweet_id
    assert TwitterCredential.find(credential.id).last_tweet_id
  end

  test "fetches loads of tweets" do
    VCR.use_cassette(:existensil_timeline) do
      fetcher.perform
      assert fetcher.results.count > 100
    end
  end

  test "fetches fetches newer and greater tweets when last is present" do
    VCR.use_cassette(:existensil_timeline) { fetcher.perform }
    VCR.use_cassette(:existensil_latest) do
      last_id = credential.last_tweet_id
      fetcher.perform
      assert fetcher.results.count < 100
      assert fetcher.results.all? {|tweet| tweet.tweet_id > last_id }
    end
  end

  private

  def fetcher
    @fetcher ||= TimelineFetcher.new(twitter_credentials(:existensil))
  end

  def credential
    @credential ||= twitter_credentials(:existensil)
  end
end
