class TwilioTextMessenger
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def call(phone_number)
    puts "Message composed as: #{message}"

    if !Rails.env.production?
			account_sid = ENV['TWILIO_DEVELOPMENT_ACCOUNT_SID']
			auth_token = ENV['TWILIO_DEVELOPMENT_AUTH_TOKEN']
      client = Twilio::REST::Client.new account_sid, auth_token
      client.messages.create({
        from: ENV['TWILIO_DEVELOPMENT_PHONE_NUMBER'],
        to: "#{phone_number}",
        body: message
      })
    else
			account_sid = ENV['TWILIO_PRODUCTION_ACCOUNT_SID']
			auth_token = ENV['TWILIO_PRODUCTION_AUTH_TOKEN']
      client = Twilio::REST::Client.new account_sid, auth_token
      client.messages.create({
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: "#{phone_number}",
        body: message
      })
    end
  end
end
