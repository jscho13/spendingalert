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

  def settings
    @user = current_user
  end

  def dashboard
    @user = current_user

    #TODO: Delete this eventually. Devise already handles it
    @user.create_mx_guid
    @user.create_stripe_id

    @user.members = get_all_memberships
    @user.update_total_spending(@user.members)
    @user.save
    @user.amount_left = @user.user_budget - @user.total_spending
  end

  def transactions
    @transactions = current_user.get_all_transactions
  end

  def send_message
    u = User.find(params[:id])
    u.notify_user
    user_json = u.to_json

    render json: user_json
  end

  def delete_mx_member
    member = get_mx_member(params[:member_guid])
    member.delete
    redirect_to dashboard_path
  end

  def checkout
  end

  def charge
    # Token is created using Checkout or Elements!
    # Get the payment token ID submitted by the form:
    token = params[:stripeToken]

    cu = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    cu.source = token
    cu.save

  if !Rails.env.production?
    subscription = Stripe::Subscription.create({
      customer: current_user.stripe_customer_id,
      items: [{plan: ENV['STRIPE_TEST_PLAN_ID']}]
    })
  else
    subscription = Stripe::Subscription.create({
      customer: current_user.stripe_customer_id,
      items: [{plan: ENV['STRIPE_PLAN_ID']}]
    })
  end

    flash.notice = "Thanks for subscribing. We've saved your payment details."
    redirect_to dashboard_path
  end


  private

  def subscription_params
    params.permit(
      :member_guid
    )
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
