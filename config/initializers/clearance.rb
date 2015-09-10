Clearance.configure do |config|
  config.allow_sign_up = false
  config.mailer_sender = ENV["MAILGUN_FROM_EMAIL"]
  config.sign_in_guards = []
end
