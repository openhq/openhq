class TeamController < ApplicationController
  def index
    fresh_when User.maximum(:updated_at)

    @team_members = User.all.sort_by {|u| User::ROLES.index(u.role) }.reverse
  end

  def new
    @user = User.new
  end

  def create
    invite_params = params.require(:user).permit(:email, project_ids: [])

    # Ensure users can only invite team members to
    # projects they have access to.
    invite_params[:project_ids].select! do |pid|
      current_user.project_ids.include?(Integer(pid)) unless pid.empty?
    end

    @user = User.invite!(invite_params)

    if @user.persisted?
      redirect_to team_index_path
    else
      render :new
    end
  end

  def edit
  end
end
