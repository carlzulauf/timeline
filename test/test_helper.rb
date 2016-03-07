ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'vcr'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def twitter_credential_defaults
    {
      twitter_id:       "123",
      twitter_nickname: "existensil",
      token:            "abc123",
      secret:           "xyz789",
    }
  end
end

VCR.configure do |c|
  c.hook_into :faraday
  c.cassette_library_dir = "test/cassettes"
  # c.allow_http_connections_when_no_cassette = true
end
