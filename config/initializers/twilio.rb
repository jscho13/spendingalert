Twilio.configure do |config|
  config.account_sid = ENV['TWILIO_PRODUCTION_ACCOUNT_SID']
  config.auth_token = ENV['TWILIO_PRODUCTION_AUTH_TOKEN']
end
