class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: ENV['MAILGUN_FROM_EMAIL']
  layout 'mailer'
end
