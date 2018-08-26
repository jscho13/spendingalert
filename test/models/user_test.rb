require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def passing_notification_interval(user, interval, time)
    user.notification_interval = interval
    Timecop.freeze(time) do
      assert user.notification_date?
    end
  end

  def failing_notification_interval(user, interval, time)
    user.notification_interval = interval
    Timecop.freeze(time) do
      assert_not user.notification_date?
    end
  end

  test "notification_date? notifies on proper date/when limit is hit" do
    test_user = users(:one)
    def test_user.get_all_transactions
      a = Transaction.new
      b = Transaction.new
      a.amount = 600
      b.amount = 200
      [a, b]
    end

    fifth_date = Time.local(2018, 9, 5, 12, 0, 0)
    weekly_date = Time.local(2018, 9, 7, 12, 0, 0)
    passing_notification_interval(test_user, "interval_5_days", fifth_date)
    passing_notification_interval(test_user, "interval_weekly", weekly_date)
    passing_notification_interval(test_user, "interval_limit", fifth_date)
  end

  test "notification_date? fails properly" do
    test_user = users(:one)
    def test_user.get_all_transactions
      a = Transaction.new
      b = Transaction.new
      a.amount = 200
      b.amount = 200
      [a, b]
    end

    fifth_date = Time.local(2018, 9, 6, 12, 0, 0)
    weekly_date = Time.local(2018, 9, 8, 12, 0, 0)
    failing_notification_interval(test_user, "interval_5_days", fifth_date)
    failing_notification_interval(test_user, "interval_weekly", weekly_date)
    failing_notification_interval(test_user, "interval_limit", fifth_date)
  end

  test "compose an under budget message" do
    test_user = users(:one)
    message = test_user.compose_message
    assert message == "SpendingAlert:\n\n$500 Spending Limit\n\n$400 Spent so far\n\n$100 left to spend!\n\n\nGood job you are on track to save this month!\n"
  end

  test "compose an over budget message" do
    test_user = users(:one)
    test_user.total_spending = 600
    message = test_user.compose_message
    assert message == "SpendingAlert:\n\n$500 Spending Limit\n\n$600 Spent so far\n\nYou've overspent by $100!\n\n\nSlow down your on a spending spree!\n"
  end
end
