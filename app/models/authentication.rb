# == Schema Information
#
# Table name: authentications
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  credential_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Authentication < ApplicationRecord
  belongs_to :user
  belongs_to :credential, class_name: "TwitterCredential"
end
