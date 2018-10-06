class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def accounts
    @user = current_user
    @user.members = get_all_memberships

    get_connect_widget
  end

  def budget 
    @user = current_user
  end

  def dashboard
    @user = current_user
    @user.has_guid? #TODO: move this into Devise controller to run once
    @user.members = get_all_memberships

    @transactions = current_user.get_all_transactions
    @user.updated_total_spending = @transactions.sum(&:amount)
    @user.amount_left = @user.user_budget - @user.updated_total_spending
  end

  def transactions
    @transactions = current_user.get_all_transactions
  end

  def send_messages
    users_to_be_notified = get_unnotified_users
    users_to_be_notified.each do |u|
      u.notify_user
    end
    users_json = users_to_be_notified.to_json

    render json: users_json  
  end

  def delete_mx_member
    member = get_mx_member(params[:member_guid])
    member.delete
    redirect_to dashboard_path
  end

  def checkout
  end

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

  def subscription_params
    params.permit(
      :member_guid
    )
  end

  def get_unnotified_users
    unnotified_users = valid_users = invalid_users = []
    mx_users = get_all_mx_users

    mx_users.map do |u|
      begin
        lu = User.find(u.identifier.to_i)
        valid_users << lu
      rescue
        invalid_users << lu
      end
    end
    valid_users.compact!
    puts "Valid users: #{valid_users}"
    puts "Invalid users: #{invalid_users}"
    valid_users.each do |u|
      if u.notification_date?
        unnotified_users << u
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

  def get_all_mx_users
    ::Atrium::User.list
  end

  def get_mx_member(member_guid)
    ::Atrium::Member.read user_guid: "#{current_user.guid}", member_guid: "#{member_guid}"
  end

end
