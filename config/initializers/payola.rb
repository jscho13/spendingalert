Payola.configure do |config|
  # Example subscription:
  # 
  # config.subscribe 'payola.package.sale.finished' do |sale|
  #   EmailSender.send_an_email(sale.email)
  # end
  # 
  # In addition to any event that Stripe sends, you can subscribe
  # to the following special payola events:
  #
  #  - payola.<sellable class>.sale.finished
  #  - payola.<sellable class>.sale.refunded
  #  - payola.<sellable class>.sale.failed
  #
  # These events consume a Payola::Sale, not a Stripe::Event
  #
  # Example charge verifier:
  #
  # config.charge_verifier = lambda do |sale|
  #   raise "Nope!" if sale.email.includes?('yahoo.com')
  # end

  # Keep this subscription unless you want to disable refund handling
  config.subscribe 'charge.refunded' do |event|
    sale = Payola::Sale.find_by(stripe_id: event.data.object.id)
    sale.refund! unless sale.refunded?
  end

	# This needs to be populated with something real
  config.secret_key = 'sk_live_iwillnevertell'
  config.publishable_key = 'pk_live_iguessicantell'

  # config.default_currency = 'gbp'

  # Prevent more than one active subscription for a given user
  config.charge_verifier = lambda do |event|
    user = User.find_by(email: event.email)
    if event.is_a?(Payola::Subscription) && user.subscriptions.active.any?
      raise "Error: This user already has an active <plan_class>."
    end
    event.owner = user
    event.save!
  end

  # Send create subscription email
  config.subscribe("customer.subscription.created") do |event|
    subscription = Payola::Subscription.find_by(stripe_id: event.data.object.id)
    YourCustomMailer.new_<plan_class>_email(subscription.id).deliver
  end

  config.subscribe("customer.subscription.updated") do |event|
    subscription = Payola::Subscription.find_by(stripe_id: event.data.object.id)
    if event.as_json.dig("data", "previous_attributes").key?("items")
      # Send upgrade subscription email
      old_amount = event.as_json.dig("data", "previous_attributes", "items", "data").first.dig("plan").fetch("amount")
      YourCustomMailer.upgrade_<plan_class>_email(old_amount, subscription.id).deliver
    else
      # Send cancel subscription email
      YourCustomMailer.cancel_<plan_class>_email(subscription.id).deliver
    end
  end

end
