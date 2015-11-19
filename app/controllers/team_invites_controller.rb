class TeamInvitesController < ApplicationController
  skip_before_action :require_login
  skip_before_action :user_belongs_to_team!
  before_action :set_team_user

  def edit
    render layout: "auth"
  end

  def update
    if @user.update(user_params)
      @team_user.accept_invite!
      sign_in @user
      redirect_to root_url, notice: "You are now signed up"
    else
      render :edit, layout: "auth"
    end
  end

  private

  def set_team_user
    @team_user = current_team.user_invites.find_by(invitation_code: params[:id])
    @user = @team_user.user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email,
      :password, :avatar)
  end
end
