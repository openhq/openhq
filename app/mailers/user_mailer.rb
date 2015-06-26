class UserMailer < ApplicationMailer

  def notification_update(user, notifications)
    @user, @notifications = user, notifications
    mail to: user.email, subject: "OpenHQ Notification Update"
  end

end