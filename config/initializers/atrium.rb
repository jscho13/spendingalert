Atrium.configure do |config|
  config.mx_api_key = ENV['MX-API-Key']
  config.mx_client_id = ENV['MX-Client-ID']
	if !Rails.env.production?
		config.base_url = "https://vestibule.mx.com" # base_url is set to "https://vestibule.mx.com" by default
	else
		config.base_url = "https://atrium.mx.com" # base_url is set to "https://vestibule.mx.com" by default
  end
end
