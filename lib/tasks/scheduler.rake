desc "Send messages"
task send_messages: :environment do
  puts "Starting daily alert task"
  include Rails.application.routes.url_helpers

  puts "Creating Rails sesssion"
  app = ActionDispatch::Integration::Session.new(Rails.application)

  puts "Hitting /send_messages"
  app.get "/send_messages"
  pp app.response.body

  puts "Done!"
end

desc "Send messages2"
task send_messages2: :environment do
  puts "Starting daily alert task"
  include Rails.application.routes.url_helpers

  puts "Creating Rails sesssion"
  app = ActionDispatch::Integration::Session.new(Rails.application)

  puts "Hitting /send_messages2"
  app.get "/send_messages2"
  pp app.response.body

  puts "Done!"
end
