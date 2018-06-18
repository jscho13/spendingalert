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

	def charge
		# Set your secret key: remember to change this to your live secret key in production
		# See your keys here: https://dashboard.stripe.com/account/apikeys
		Stripe.api_key = "sk_test_NL4whTnzoKMJgC0alcbTJ4Py"

		# Token is created using Checkout or Elements!
		# Get the payment token ID submitted by the form:
		token = params[:stripeToken]

		charge = Stripe::Charge.create({
				amount: 299,
				currency: 'usd',
				description: 'Example charge',
				source: token,
		})
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
			product: 'prod_CbvTFuXWh7BPJH',
			nickname: 'SaaS Platform USD',
			interval: 'month',
			currency: 'usd',
			amount: 299,
		})

		render json: plan
	end

	def create_subscription
		# Set your secret key: remember to change this to your live secret key in production
		# See your keys here: https://dashboard.stripe.com/account/apikeys
		Stripe.api_key = "sk_test_NL4whTnzoKMJgC0alcbTJ4Py"

		subscription = Stripe::Subscription.create({
				customer: 'cus_4fdAW5ftNQow1a',
				items: [{plan: 'plan_CBXbz9i7AIOTzr'}],
		})
	end
end
