class User < ApplicationRecord
  has_many :authentications
  has_many :authorizations

  has_many :credentials, through: :authorizations
end
