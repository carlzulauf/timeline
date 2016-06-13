# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  key        :string
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_many :authentications
  has_many :authorizations

  has_many :credentials, through: :authorizations

  def stream_tweets!(on = true)
    if on
      User::StreamOn.new(self).perform
    else
      User::StreamOff.new(self).perform
    end
  end
end
