module MailHelper
  def reset_emails!
    ActionMailer::Base.deliveries.clear
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end
end

RSpec.configure do |config|
  config.include MailHelper
end
