module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session

    before_action :require_api_token

    private

    def require_api_token
      halt_authentication_failed unless current_token
    end

    def current_token
      ApiToken.find_by(token: api_token_value)
    end

    def current_user
      current_token.user
    end
    helper_method :current_user

    def current_team
      current_token.team
    end
    helper_method :current_team

    def api_token_value
      headers["X-Api-Token"].presence || params[:api_token].presence
    end

    def halt_athentication_failed
      render json: {message: "Authentication Required", error: "API token invalid"}, status: 401
    end
  end
end
