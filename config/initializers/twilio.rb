
if Rails.env.test?
  Twilio.configure do |config|
    config.account_sid = Rails.application.credentials.development["twilio_account_sid"]
    config.auth_token = Rails.application.credentials.development["twilio_auth_token"]
  end
else
  Twilio.configure do |config|
    config.account_sid = Rails.application.credentials.production["twilio_account_sid"]
    config.auth_token = Rails.application.credentials.production["twilio_auth_token"]
  end
end
