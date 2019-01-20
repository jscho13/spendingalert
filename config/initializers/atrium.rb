if !Rails.env.production?
  GlobalAtrium = Atrium::AtriumClient.new(ENV['MX_TEST_API_KEY'], ENV['MX_TEST_CLIENT_ID'])
else
  GlobalAtrium = Atrium::AtriumClient.new(ENV['MX_API_KEY'], ENV['MX_CLIENT_ID'])
end

