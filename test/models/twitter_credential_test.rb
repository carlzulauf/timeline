require 'test_helper'

class TwitterCredentialTest < ActiveSupport::TestCase
  test "should successfully create from defaults" do
    assert TwitterCredential.create!(twitter_credential_defaults)
  end
end
