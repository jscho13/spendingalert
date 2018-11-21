Twilio.configure do |config|
  if !Rails.env.production?
    config.account_sid = ENV['TWILIO_DEVELOPMENT_ACCOUNT_SID']
    config.auth_token = ENV['TWILIO_DEVELOPMENT_AUTH_TOKEN']
  else
    config.account_sid = ENV['TWILIO_PRODUCTION_ACCOUNT_SID']
    config.auth_token = ENV['TWILIO_PRODUCTION_AUTH_TOKEN']
  end
end
