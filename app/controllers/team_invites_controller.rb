class TeamInvitesController < ApplicationController
  skip_before_action :require_login, only: [:edit, :update]
  skip_before_action :user_belongs_to_team!, only: [:edit, :update]
  before_action :set_team_user, only: [:edit, :update]

  def new
    @user = current_team.users.new
  end

  def create
    invite_params = params.require(:user).permit(:email, project_ids: [])

    # Ensure users can only invite team members to
    # projects they have access to.
    invite_params[:project_ids].select! do |pid|
      current_user.project_ids.include?(Integer(pid)) unless pid.empty?
    end

    @user = current_team.invite(invite_params, current_user)

    if @user.persisted?
      redirect_to team_index_path
    else
      render :new
    end
  end

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
