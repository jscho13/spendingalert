::Atrium.configure do |config|
  if !Rails.env.production?
    config.base_url = "https://vestibule.mx.com"
    config.mx_api_key = ENV['MX_TEST_API_KEY']
    config.mx_client_id = ENV['MX_TEST_CLIENT_ID']
  else
    config.base_url = "https://atrium.mx.com"
    config.mx_api_key = ENV['MX_API_KEY']
    config.mx_client_id = ENV['MX_CLIENT_ID']
  end
end
