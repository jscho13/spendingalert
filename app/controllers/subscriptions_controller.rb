class SubscriptionsController < ApplicationController
  def new
  end

  def create
  end

  def dashboard
    @user = current_user
  end

  def stripe
  end

  def create_product
		# Set your secret key: remember to change this to your live secret key in production
		# See your keys here: https://dashboard.stripe.com/account/apikeys
		Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']

		product = Stripe::Product.create({
			name: 'Spending Alert Subscription',
			type: 'service',
		})

		render json: product
  end

	def create_plan
		# Set your secret key: remember to change this to your live secret key in production
		# See your keys here: https://dashboard.stripe.com/account/apikeys
		Stripe.api_key = "sk_test_NL4whTnzoKMJgC0alcbTJ4Py"

		plan = Stripe::Plan.create({
			product: 'product id here',
			nickname: 'Spending Alert Monthly Subscription',
			interval: 'month',
			currency: 'usd',
			amount: 299,
		})

		render json: plan
	end

  def create_customer
		# Set your secret key: remember to change this to your live secret key in production
		# See your keys here: https://dashboard.stripe.com/account/apikeys
		Stripe.api_key = "sk_test_NL4whTnzoKMJgC0alcbTJ4Py"

		customer = Stripe::Customer.create({
			email: 'jscho13@gmail.com',
			source: 'src here',
		})
		render json: customer
	end


	def create_subscription
		# Set your secret key: remember to change this to your live secret key in production
		# See your keys here: https://dashboard.stripe.com/account/apikeys
		Stripe.api_key = "sk_test_NL4whTnzoKMJgC0alcbTJ4Py"

		subscription = Stripe::Subscription.create({
			customer: 'customer from above here',
			items: [{plan: 'plan id here'}],
		})
	end
end
