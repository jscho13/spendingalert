class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def budgeting 
    @user = current_user

    #TODO: move this into Devise controller to run once
    @user.has_guid?
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

	def mx_connect_widget
		@widget = ::Atrium::Connect.create user_guid: "#{current_user.guid}"
		puts @widget.attributes
		render "subscriptions/new", layout: false
	end
end
