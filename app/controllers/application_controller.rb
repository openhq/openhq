class ApplicationController < ActionController::Base
  include Clearance::Controller
  set_current_tenant_by_subdomain(:team, :subdomain)

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_team!
  before_action :require_login

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

  def current_team_user
    current_user.team_users.find_by(team_id: current_team.id)
  end
  helper_method :current_team_user

  def current_ability
    @current_ability ||= Ability.new(current_team_user)
  end

  def ensure_owner
    redirect_to root_url unless current_team_user.role?(:owner)
  end

  def all_other_users
    current_team.users.where("users.id != ?", current_user.id).not_deleted
  end
  helper_method :all_other_users

  def get_first_error(object)
    object.errors.full_messages.first
  end

  def notify(subject, actions_performed)
    Array(actions_performed).each do |action|
      NotificationService.new(subject, action).notify
    end
  end

end
