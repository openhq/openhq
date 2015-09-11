module Settings
  class TeamsController < ApplicationController
    before_action :set_team

    def show
    end

    def update
      @team.update(team_params)
    end

    def leave
      @team.team_users.find_by(user_id: current_user.id).destroy
      redirect_to root_app_url, notice: "You have left #{@team.name}"
    end

    private

    def set_team
      @team = current_user.teams.find_by(subdomain: params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :subdomain)
    end

  end
end
