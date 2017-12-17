module Api
  class BaseController < ActionController::Base
    include NotifyConcern
    include CurrentTeamAbilityConcern

    protect_from_forgery with: :null_session

    before_action :require_api_token
    before_action :set_current_team

    set_current_tenant_through_filter

    private

    def serialize_collection(scope)
      scope.map { |obj| ActiveModelSerializers::SerializableResource.new(obj, root: :root_key_name).serializable_hash[:root_key_name] }
    end

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
      @current_user ||= current_token.try(:user)
    end
    helper_method :current_user

    def current_team
      @current_team ||= current_token.try(:team)
    end
    helper_method :current_team

    def set_current_team
      set_current_tenant(current_team)
    end
  end
end
