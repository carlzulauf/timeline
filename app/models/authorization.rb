class Authorization < ApplicationRecord
  belongs_to :user
  belongs_to :credential, class_name: "TwitterCredential"
end
