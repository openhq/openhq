class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILGUN_FROM_EMAIL']
  layout 'mailer'
end
