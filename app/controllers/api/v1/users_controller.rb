module Api
  module V1
    class UsersController < BaseController
      resource_description do
        short "Get information about the teams users"
        formats ["json"]
      end

      api! "Fetch all users for the team"
      def index
        users = current_team.team_users.includes(:user).map do |team_user|
          team_user.user.role = team_user.role
          team_user.user
        end

        render json: users
      end
    end
  end
end
