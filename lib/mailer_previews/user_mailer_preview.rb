# Notes: https://github.com/rails/rails/blob/master/guides/source/4_1_release_notes.md#action-mailer-previews
# Preview: http://openhq.dev/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def notification_update
    UserMailer.notification_update(User.first)
  end

  def team_invite
    invite = TeamUser.find_by!(status: "invited")
    UserMailer.team_invite(invite, User.first)
  end

  def change_password
    UserMailer.change_password(User.first)
  end

  def password_changed
    UserMailer.password_changed(User.first)
  end
end
