class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: ENV['DEFAULT_FROM_EMAIL']
  layout 'mailer'
end
