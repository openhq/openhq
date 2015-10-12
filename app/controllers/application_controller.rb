require "route_constraints/subdomain"

class ApplicationController < ActionController::Base
  include Clearance::Controller

  set_current_tenant_through_filter
  before_action :set_current_team

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_team_exists_for_subdomain!
  before_action :require_login
  before_action :user_belongs_to_team!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def multisite_install
    Rails.application.config.multisite
  end
  helper_method :multisite_install

  def root_app_url
    Rails.application.secrets.application_url
  end
  helper_method :root_app_url

  def root_app_host
    URI.parse(root_app_url).host
  end
  helper_method :root_app_host

  def set_current_team
    if multisite_install
      if request.subdomain.present?
        team = Team.find_by!(subdomain: request.subdomain)
        set_current_tenant(team)
      end
    else
      team = Team.only_team
      set_current_tenant(team)
    end
  end

  def ensure_team_exists_for_subdomain!
    if RouteConstraints::Subdomain.matches?(request)
      redirect_to root_app_url unless current_team
    end
  end

  # If there is a current team loaded ensure the signed in user
  # is a member or else take them back to the root site
  def user_belongs_to_team!
    if signed_in? && current_team.present?
      redirect_to root_app_url unless current_team_role
    end
  end

  def current_team
    ActsAsTenant.current_tenant
  end
  helper_method :current_team

  def current_team_role
    current_user.team_users.find_by(team_id: current_team.id)
  end
  helper_method :current_team_role

  def current_ability
    @current_ability ||= Ability.new(current_team_role)
  end

  def ensure_owner
    redirect_to root_url unless current_team_role.role?(:owner)
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
      NotificationService.new(subject, action, current_user).notify
    end
  end

end
