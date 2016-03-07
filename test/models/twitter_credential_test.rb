require 'test_helper'

class TwitterCredentialTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should successfully create from defaults" do
    assert TwitterCredential.create!(twitter_credential_defaults)
  end
end
