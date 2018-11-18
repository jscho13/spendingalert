class TwilioTextMessenger
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def call(phone_number)
    client = Twilio::REST::Client.new
    if !Rails.env.production?
      client.messages.create({
        from: ENV['TWILIO_DEVELOPMENT_PHONE_NUMBER'],
        to: "#{phone_number}",
        body: message
      })
    else
      client.messages.create({
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: "#{phone_number}",
        body: message
      })
    end
  end
end
