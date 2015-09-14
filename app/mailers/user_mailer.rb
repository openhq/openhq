class UserMailer < ApplicationMailer
  add_template_helper(PresenterHelper)
  add_template_helper(TagHelper)

  def welcome(user)
    @user = user
    mail to: user.email, subject: "Welcome to Open HQ"
  end

  def notification_update(user)
    @user = user
    @notifications = user.notifications.undelivered
    @notifications.each(&:delivered!)

    mail to: user.email, subject: "Open HQ Notification Update"
  end

  def team_invite(team_invite, inviter)
    @team = team_invite.team
    @user = team_invite.user
    @team_invite = team_invite
    @inviter = inviter
    mail to: @user.email, subject: "You have been invited to join a team on Open HQ"
  end

  def change_password(user)
    @user = user
    mail(
      to: @user.email,
      subject: I18n.t(
        :change_password,
        scope: [:clearance, :models, :clearance_mailer],
        default: "Change your password"
      )
    )
  end

end
