module Api
  module V1
    class AuthController < BaseController
      skip_before_action :require_api_token
      skip_before_action :set_current_team

      def index
        user = Clearance.configuration.user_model.authenticate(
          params[:email], params[:password]
        )
        team = Team.find_by(subdomain: params[:subdomain])

        if user.present? && team.present? && user.team_ids.include?(team.id)
          api_token = ApiToken.for(user, team)
          render json: api_token, scope: nil
        else
          render json: "Credentials invalid: Access denied.", status: 401
        end
      end
    end
  end
end