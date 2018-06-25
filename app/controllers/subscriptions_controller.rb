class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def budgeting 
    @user = current_user
    
# This is where you last left off. Create an mx user when the user first signs in.
#     if @user.is_first_sign_in?
#       mx_create_user
#     end
  end

  def payment
  end

  def charge
		customer = Stripe::Customer.create({
			email: 'jscho13@gmail.com',
			source: params[:stripeToken],
		})

		subscription = Stripe::Subscription.create({
			customer: customer["id"],
			items: [{plan: 'plan_D52dfQ7ohJSpzR'}],
		})

		render json: subscription
  end

  def mx_create_user
    render json: user.attributes
  end

  def mx_list_users
		users = ::Atrium::User.list
    render json: users
  end

	def mx_connect_widget
		@widget = ::Atrium::Connect.create user_guid: "USR-7f83326a-a003-fc1f-ee2a-1415bb6986b0"
		puts @widget.attributes
		render "subscriptions/new", layout: false
	end

end
