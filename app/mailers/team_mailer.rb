class TeamMailer < ApplicationMailer
  def setup(team, user)
    @team = team
    @user = user
    mail to: user.email, subject: "Welcome to Open HQ"
  end
end
