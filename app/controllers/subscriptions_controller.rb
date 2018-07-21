class SubscriptionsController < ApplicationController
  def accounts
    get_connect_widget
  end

  def budget 
    @user = current_user
  end

  def dashboard
    @user = current_user
    @user.has_guid? #TODO: move this into Devise controller to run once
    @user.members = get_all_memberships

    transactions = get_all_transactions
    @user.total_spending = transactions.sum(&:amount)
  end

  def send_message
    @user = current_user
    message = "SpendingAlert:\n
              $#{@user.user_budget} Spending Limit\n
              $#{@user.current_spending} Spent so far\n
              $#{@user.user_budget-@user.current_spending} left to spend or save!"
    TwilioTextMessenger.new(message).call(@user.phone_number)
  end

  def send_messages
    users_to_be_notified = get_unnotified_users
    users_to_be_notified.each do |u|
      user = User.find(u.id)
      user.send_message
    end
  end

#   def payment
#   end
# 
#   def charge
#     customer = Stripe::Customer.create({
#       email: 'jscho13@gmail.com',
#       source: params[:stripeToken],
#     })
# 
#     subscription = Stripe::Subscription.create({
#       customer: customer["id"],
#       items: [{plan: 'plan_D52dfQ7ohJSpzR'}],
#     })
# 
#     render json: subscription
#   end

  private

  def get_unnotified_users
    members = get_all_memberships
    members.each do |m|
      if m.notificationDate?(m) 
        m.notify_user
      end
    end
  end

  def notificationDate?(member)
    case user.notificationInterval
    when "interval_5_days"
      check_interval_5_days
    when "interval_weekly"
      check_interval_weekly
    when "interval_percent"
      check_interval_value(member, "notification_percent")
    when "interval_limit"
      check_interval_value(member, "user_budget ")
    else 
      log_stderr("User #{current_user.id}: has no interval")
      return false;
    end
  end

  def check_interval_5_days
    today = Date.today
    [5, 10, 15, today.end_of_month.mday].include?(today.mday)
  end

  def check_interval_weekly
    today = Date.today
    [7, 14, 21, today.end_of_month.mday].include?(today.mday)
  end

  def check_interval_value(member, field)
    today = Date.today.mday
    member.alertSentFlag = true if today == 1

    if !member.alertSentFlag
      if current_user["#{field}"] < member.total_spending 
        return false
      else
        member.alertSentFlag = true
        return true
      end
    end
  end

  def get_connect_widget
    @widget = ::Atrium::Connect.create user_guid: "#{current_user.guid}"
  end

  def get_all_memberships
    ::Atrium::Member.list user_guid: "#{current_user.guid}"
  end

  def get_all_transactions
    params = { user_guid: current_user.guid, from_date: (Date.today.at_beginning_of_month).to_s }
    ::Atrium::Transaction.list params
  end
end
