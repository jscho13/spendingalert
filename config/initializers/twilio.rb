
if Rails.env.test?
  Twilio.configure do |config|
    config.account_sid = ENV['TWILIO_DEVELOPMENT_ACCOUNT_SID']
    config.auth_token = ENV['TWILIO_DEVELOPMENT_AUTH_TOKEN']
  end
else
  Twilio.configure do |config|
    config.account_sid = ENV['TWILIO_PRODUCTION_ACCOUNT_SID']
    config.auth_token = ENV['TWILIO_PRODUCTION_AUTH_TOKEN']
  end
end
