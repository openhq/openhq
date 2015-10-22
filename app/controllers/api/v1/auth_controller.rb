module Api
  module V1
    class AuthController < BaseController
      skip_before_action :require_api_token
      skip_before_action :set_current_team

      def create
        user = Clearance.configuration.user_model.authenticate(
          params[:email], params[:password]
        )

        if user.present? && user.teams.any?
          render json: ApiToken.for(user, user.teams.first), scope: nil
        else
          render json: "Credentials invalid: Access denied.", status: 401
        end
      end
    end
  end
end