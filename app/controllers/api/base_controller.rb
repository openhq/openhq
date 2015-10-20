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
      errors = object.errors.messages.map do |field, error_messages|
        {field: field, errors: error_messages}
      end

      render json: {message: "Validation Failed", errors: errors}, status: 422
    end

    def require_api_token
      request_http_token_authentication unless current_token
    end

    def current_token
      @current_token ||=
        authenticate_with_http_token do |token, _options|
          ApiToken.find_by(token: token)
        end
    end

    def current_user
      @current_user ||= current_token.user
    end
    helper_method :current_user

    def current_team
      @current_team ||= current_token.team
    end
    helper_method :current_team

    def set_current_team
      set_current_tenant(current_team)
    end
  end
end
