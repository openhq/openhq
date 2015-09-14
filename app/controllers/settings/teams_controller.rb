module Settings
  class TeamsController < ApplicationController
    before_action :set_team, except: [:new, :create]

    def show
    end

    def new
      @team = Team.new
    end

    def create
      @team = Team.new(team_params)

      if @team.save
        @team.team_users.create!(user: current_user, role: "owner")

        redirect_to root_url(subdomain: @team.subdomain)
      else
        render :new
      end
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
      @team = current_user.teams.find_by!(subdomain: params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :subdomain)
    end

  end
end
