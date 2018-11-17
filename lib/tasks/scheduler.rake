desc "Send daily alert"
task send_daily_alerts: :environment do
  puts "Starting daily alert task"
  include Rails.application.routes.url_helpers

  puts "Creating Rails sesssion"
  app = ActionDispatch::Integration::Session.new(Rails.application)

  puts "Signing in"
  app.get '/users/sign_in'
  csrf_token = app.session[:_csrf_token]
  p csrf_token
  app.post('/users/sign_in', { params: { authenticity_token: csrf_token, user: {email: ENV['SA_EMAIL'], password: ENV['SA_PASSWORD'] }}})

  puts "Succesfully logged in"
  app.get ''
  csrf_token = app.session[:_csrf_token]
  p csrf_token

  puts "Hitting /dashboard"
  app.get "/dashboard"

  puts "Hitting /send_messages"
  app.get "/send_messages"

  puts app.response.body
  puts "Done!"
end
