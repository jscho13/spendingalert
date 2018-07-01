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

  def get_connect_widget
    @widget = ::Atrium::Connect.create user_guid: "#{current_user.guid}"
  end

  def get_all_memberships
    ::Atrium::Member.list user_guid: "#{current_user.guid}"
  end

  def get_all_transactions
    params = { user_guid: current_user.guid }
    ::Atrium::Transaction.list params
  end
end
