
if Rails.env.test?
  Twilio.configure do |config|
    config.account_sid = 'AC0835263addfe7d51a3590a33400948fc'
    config.auth_token = 'd06e8d88fc06d0553d787dfe1c4efe93'
  end
else
  Twilio.configure do |config|
    config.account_sid = 'AC05a45e40f0168daf35513df3473eaa3b'
    config.auth_token = '68c7262e6932da5d5a7abda45f7f6ebc'
  end
end
