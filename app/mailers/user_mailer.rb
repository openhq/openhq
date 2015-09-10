class UserMailer < ApplicationMailer
  add_template_helper(PresenterHelper)
  add_template_helper(TagHelper)

  def notification_update(user)
    @user = user
    @notifications = user.notifications.undelivered
    @notifications.each(&:delivered!)

    mail to: user.email, subject: "OpenHQ Notification Update"
  end

  def team_invite(team_invite, inviter)
    @team = team_invite.team
    @user = team_invite.user
    @team_invite = team_invite
    @inviter = inviter
    mail to: @user.email, subject: "You have been invited to join a team on Open HQ"
  end

end
