class UserMailer < ApplicationMailer
  add_template_helper(PresenterHelper)
  add_template_helper(TagHelper)

  def notification_update(user)
    @user = user
    @notifications = user.notifications.undelivered

    mail to: user.email, subject: "OpenHQ Notification Update"
  end

end