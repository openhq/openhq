class TeamController < ApplicationController
  before_action :set_user_and_team_member, except: :index

  def index
    fresh_when current_team.users.maximum(:updated_at)

    members = current_team.team_users.includes(:user).sort_by {|tu| TeamUser::ROLES.index(tu.role) }.reverse
    invites = current_team.user_invites.includes(:user).to_a

    @team_members = [members, invites].flatten
  end

  def show
    fresh_when last_modified: @team_member.updated_at
  end

  def update
    authorize! :update, @team_member
    @team_member.update(team_user_params)
    redirect_to team_path(@user.username), notice: "User has been updated"
  end

  def destroy
    authorize! :destroy, @team_member
    @team_member.destroy
    redirect_to team_index_path, notice: "#{@user.username} has been removed from the team"
  end

  private

  def set_user_and_team_member
    @user = current_team.users.find_by!(username: params[:id])
    @team_member = current_team.team_users.find_by!(user_id: @user.id)
  end

  def team_user_params
    params.require(:team_user).permit(:role)
  end
end
