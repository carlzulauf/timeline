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

class TwitterCredential < ApplicationRecord
  has_one :authentication, foreign_key: :credential_id
  has_one :user, through: :authentication

  has_many :authorizations, foreign_key: :credential_id
  has_many :tweets, foreign_key: :credential_id

  validates :token, :secret, :twitter_id, presence: true

  def create_authentication_with_new_user
    user = User.create(key: twitter_nickname, name: name, email:  email)
    authorizations.create(user: user)
    create_authentication(user: user)
  end

  def name
    auth_hash.dig("info", "name")
  end

  def email
    auth_hash.dig("info", "email")
  end

  def nickname
    twitter_nickname
  end

  def rest_client
    Twitter::REST::Client.new(&setup_client)
  end

  def streaming_client
    Twitter::Streaming::Client.new(&setup_client)
  end

  def setup_client
    -> (client) {
      app = Rails.application.secrets.twitter
      client.consumer_key         = app["consumer_key"]
      client.consumer_secret      = app["consumer_secret"]
      client.access_token         = token
      client.access_token_secret  = secret
    }
  end

  def tweet_from_native_if_unique(native)
    tweets.from_native_if_unique(native).tap {|t| last_tweet! t }
  end

  def tweet_from_native(native)
    tweets.from_native(native)
  end

  def last_tweet!(t)
    if last_tweet_id.nil? || t.tweet_id > last_tweet_id
      update(last_tweet_id: t.tweet_id)
    end
  end

  def self.from_omniauth(auth_hash)
    return unless auth_hash["uid"]
    find_or_initialize_by(twitter_id: auth_hash["uid"]).tap do |c|
      c.twitter_nickname  = auth_hash.dig("info", "nickname")
      c.token             = auth_hash.dig("credentials", "token")
      c.secret            = auth_hash.dig("credentials", "secret")
      c.auth_hash         = auth_hash
      c.save!
    end
  end
end
