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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Carl should have one authentication" do
    assert_equal 1, users(:carl).authentications.count
  end

  test "Carl should have two authorizations and credentials" do
    assert_equal 2, users(:carl).authorizations.count
    assert_equal 2, users(:carl).credentials.count
  end
end
