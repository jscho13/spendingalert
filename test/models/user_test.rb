require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "notification_date?" do
    user_one = users(:one)
    user_two = users(:two)

    # do the notification_date? method
    # check the intervals 5 days, weekly, percent, and limit
    # get a positive and negative method for each
    # you'll need to set a correct date and incorrect date

    assert true
  end
end
