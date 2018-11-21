desc "Send messages"
task send_messages: :environment do
  puts "Starting daily alert task"
  include Rails.application.routes.url_helpers

  puts "Creating Rails sesssion"
  app = ActionDispatch::Integration::Session.new(Rails.application)

  p ENV
  puts "Hitting /send_messages"
  app.get "/send_messages"
  pp app.response
  pp app.response.body

  puts "Done!"
end

desc "Send messages2"
task send_messages2: :environment do
  puts "Starting daily alert task"
  include Rails.application.routes.url_helpers

  puts "Creating Rails sesssion"
  app = ActionDispatch::Integration::Session.new(Rails.application)
  app.get '/users/sign_in'
  p csrf_token = app.session[:_csrf_token]

  app.post '/users/sign_in',{:params => {:authenticity_token => csrf_token, :user => {:email => ENV['SA_EMAIL'], :password => ENV['SA_PASSWORD']}}}
  app.get ''

  p csrf_token = app.session[:_csrf_token]
  puts "Hitting /send_messages2"
  app.get "/send_messages2"
  pp app.response
  pp app.response.body

  puts "Done!"
end
