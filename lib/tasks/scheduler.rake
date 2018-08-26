desc "Send daily alert"
task send_daily_alerts: :environment do
  puts "sending daily alerts..."
  include Rails.application.routes.url_helpers
  app = ActionDispatch::Integration::Session.new(Rails.application)
  app.get "/send_messages"
  puts "...sent."
end
