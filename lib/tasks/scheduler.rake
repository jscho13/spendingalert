desc "Send daily alert"
task send_daily_alerts: :environment do
  puts "Starting daily alert task"
  include Rails.application.routes.url_helpers

  puts "Creating Rails sesssion"
  app = ActionDispatch::Integration::Session.new(Rails.application)

  puts "Hitting /send_messages"
  app.get "/send_messages"

  puts "Done!"
end
