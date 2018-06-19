class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def budgeting
    @user = current_user
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

  def new
  end
end
