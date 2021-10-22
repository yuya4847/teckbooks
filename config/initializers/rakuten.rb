RakutenWebService.configure do |c|
  if Rails.env == 'production'
    c.application_id = ENV['RWS_PRO_APPLICATION_ID']
  end
  if Rails.env == 'development'
    c.application_id = ENV['RWS_DEV_APPLICATION_ID']
  end
end
