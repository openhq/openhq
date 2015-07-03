class ApplicationMailer < ActionMailer::Base
  default from: "noreply@openhq.com"
  layout 'mailer'
end