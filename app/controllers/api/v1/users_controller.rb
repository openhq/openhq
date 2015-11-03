module Api
  module V1
    class UsersController < BaseController
      resource_description do
        short "Get information about the teams users"
        formats ["json"]
      end

      api! "Fetch all users for the team"
      def index
        render json: current_team.users
      end
    end
  end
end
