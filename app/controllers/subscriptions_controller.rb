class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
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

  def dashboard
    @user = current_user
  end

  def stripe
  end

  def create_product_plan
		product = Stripe::Product.create({
			name: 'Spending Alert Subscription',
			type: 'service',
		})

		plan = Stripe::Plan.create({
			product: product["id"],
			nickname: 'Spending Alert Monthly Subscription',
			interval: 'month',
			currency: 'usd',
			amount: 299,
		})

    render json: plan
  end
end
