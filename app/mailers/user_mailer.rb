class UserMailer < ApplicationMailer
  include PresenterHelper
  include TagHelper

  def notification_update(user)
    @user = user
    @notifications = user.notifications.undelivered

    mail to: user.email, subject: "OpenHQ Notification Update"
  end

end