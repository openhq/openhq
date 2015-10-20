module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session

    skip_before_action :set_current_team
    skip_before_action :run_first_time_setup
    skip_before_action :ensure_team_exists_for_subdomain!
    skip_before_action :require_login
    skip_before_action :user_belongs_to_team!

    before_action :require_api_token
    before_action :set_current_team

    private

    def render_errors(object)
      render json: {message: "Validation Failed", errors: object.errors.full_messages}, status: 422
    end

    def require_api_token
      halt_authentication_failed unless current_token
    end

    def current_token
      @current_token ||= ApiToken.find_by(token: api_token_value)
    end

    def current_user
      @current_user ||= current_token.user
    end
    helper_method :current_user

    def current_team
      @current_team ||= current_token.team
    end
    helper_method :current_team

    def api_token_value
      request.headers["HTTP_X_API_TOKEN"].presence || params[:api_token].presence
    end

    def halt_authentication_failed
      render json: {message: "Authentication Required", error: "API token invalid"}, status: 401
    end
  end
end
