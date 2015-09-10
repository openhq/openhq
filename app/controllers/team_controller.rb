class TeamController < ApplicationController
  def index
    fresh_when current_team.users.maximum(:updated_at)

    @team_members = current_team.team_users.includes(:user).sort_by {|tu| TeamUser::ROLES.index(tu.role) }.reverse
  end

  def show
    @user = current_team.users.find_by!(username: params[:id])
    @team_member = current_team.team_users.find_by!(user_id: @user.id)
    fresh_when last_modified: @team_member.updated_at
  end

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
