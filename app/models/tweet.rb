# == Schema Information
#
# Table name: tweets
#
#  id            :integer          not null, primary key
#  credential_id :integer
#  tweet_id      :string
#  info          :json
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Tweet < ApplicationRecord
  belongs_to :credential, class_name: "TwitterCredential"

  def self.from_native_tweet(native)
    create(info: native.to_h, tweet_id: native.id)
  end
end
