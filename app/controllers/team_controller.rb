class TeamController < ApplicationController
  def index
    fresh_when current_team.users.maximum(:updated_at)

    members = current_team.team_users.includes(:user).sort_by {|tu| TeamUser::ROLES.index(tu.role) }.reverse
    invites = current_team.user_invites.includes(:user).to_a

    @team_members = [members, invites].flatten
  end

  def show
    @user = current_team.users.find_by!(username: params[:id])
    @team_member = current_team.team_users.find_by!(user_id: @user.id)
    fresh_when last_modified: @team_member.updated_at
  end
end
