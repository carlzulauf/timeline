class Tweet < ApplicationRecord
  belongs_to :credential, class_name: "TwitterCredential"

  def self.from_native_tweet(native)
    create(info: native.to_h, tweet_id: native.id)
  end
end
