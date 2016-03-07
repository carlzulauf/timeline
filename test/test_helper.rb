ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

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
