require 'test_helper'

class TimelineStreamerTest < ActiveSupport::TestCase
  test "fetches tweets in real time" do
    assert streamer.perform_with_timeout(2)
  end

  private

  def streamer
    @streamer ||= TimelineStreamer.new(twitter_credentials(:existensil))
  end

  def credential
    @credential ||= twitter_credentials(:existensil)
  end
end
