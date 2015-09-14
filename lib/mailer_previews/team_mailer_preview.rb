# Notes: https://github.com/rails/rails/blob/master/guides/source/4_1_release_notes.md#action-mailer-previews
# Preview: http://openhq.dev/rails/mailers/user_mailer
class TeamMailerPreview < ActionMailer::Preview
  def setup
    TeamMailer.setup(Team.first, User.first)
  end
end
