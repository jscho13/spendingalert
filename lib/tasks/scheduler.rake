desc "Send messages"
task send_messages: :environment do
  puts "Starting daily alert task"
  include Rails.application.routes.url_helpers

  puts "Creating Rails sesssion"
  app = ActionDispatch::Integration::Session.new(Rails.application)

  p ENV
  puts "Hitting /send_messages"
  app.get "/send_messages"

  puts "Done!"
end
