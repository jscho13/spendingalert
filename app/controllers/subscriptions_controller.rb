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

    transactions = get_all_transactions(current_user)
    @user.updated_total_spending = transactions.sum(&:amount)
  end

  def send_messages
    users_to_be_notified = get_unnotified_users
    users_to_be_notified.each do |u|
      user = User.find(u.id)
      user.notify_user
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
    unnotified_users = []
    mx_users = get_all_mx_users
    users = mx_users.map { |u| User.find(u.identifier.to_i) }
    users.each do |u|
      if u.notification_date?
        transactions = get_all_transactions(u)
        u.total_spending = transactions.sum(&:amount)

        unnotified_users << u.id    
      end
    end
    unnotified_users 
  end

  def get_connect_widget
    @widget = ::Atrium::Connect.create user_guid: "#{current_user.guid}"
  end

  def get_all_memberships
    ::Atrium::Member.list user_guid: "#{current_user.guid}"
  end

  def get_all_transactions(user)
    params = { user_guid: user.guid, from_date: (Date.today.at_beginning_of_month).to_s }
    ::Atrium::Transaction.list params
  end

  def get_all_users
    ::Atrium::User.list
  end
end
