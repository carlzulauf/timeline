# == Schema Information
#
# Table name: twitter_credentials
#
#  id               :integer          not null, primary key
#  twitter_id       :string
#  twitter_nickname :string
#  token            :string
#  secret           :string
#  auth_hash        :json
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  last_tweet_id    :string
#

require 'test_helper'

class TwitterCredentialTest < ActiveSupport::TestCase
  test "should successfully create from defaults" do
    assert TwitterCredential.create!(twitter_credential_defaults)
  end
end
