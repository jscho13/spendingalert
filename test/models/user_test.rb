require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "notification_date? notifies on proper date/when limit is hit" do
    user_one = users(:one)
    def user_one.get_all_transactions
      a = Transaction.new
      b = Transaction.new
      a.amount = 600
      b.amount = 200
      [a, b]
    end

    user_one.notification_interval = "interval_5_days"
    fifth_date = Time.local(2018, 9, 5, 12, 0, 0)
    Timecop.freeze(fifth_date) do
      assert user_one.notification_date?
    end
    
    user_one.notification_interval = "interval_weekly"
    weekly_date = Time.local(2018, 9, 7, 12, 0, 0)
    Timecop.freeze(weekly_date) do
      assert user_one.notification_date?
    end

    user_one.notification_interval = "interval_limit"
    weekly_date = Time.local(2018, 9, 7, 12, 0, 0)
    Timecop.freeze(weekly_date) do
      assert user_one.notification_date?
    end
  end
end
