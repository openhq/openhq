class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:team, :subdomain)

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_team!
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def ensure_team!
    unless current_team
      redirect_to root_url(host: request.domain)
    end
  end

  def current_team
    ActsAsTenant.current_tenant
  end
  helper_method :current_team

  def ensure_owner
    redirect_to root_url unless current_user.role?(:owner)
  end

  def all_other_users
    User.where("users.id != ?", current_user.id).not_deleted
  end
  helper_method :all_other_users

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << :login
    devise_parameter_sanitizer.for(:accept_invitation) << [:first_name, :last_name, :username]
    # devise_parameter_sanitizer.for(:sign_up) << [:username, :email, :first_name, :last_name]
    # devise_parameter_sanitizer.for(:account_update) << [:username, :email, :first_name, :last_name]
  end

  def get_first_error(object)
    object.errors.full_messages.first
  end

  def notify(subject, actions_performed)
    Array(actions_performed).each do |action|
      NotificationService.new(subject, action).notify
    end
  end

end
