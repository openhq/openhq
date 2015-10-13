class SetupController < ApplicationController
  layout "setup"
  skip_before_action :require_login
  skip_before_action :run_first_time_setup
  before_action :ensure_single_site_install, only: [:first_time_user, :create_first_user]
  before_action :ensure_no_users, only: [:first_time_user, :create_first_user]

  # Multisite setup
  def index
    # Ensure the setup code is valid
    team = Team.find_by!(setup_code: params[:code])

    # Sign in the first and only user
    sign_in team.users.first
  end

  def update_user
    if current_user.update(user_params)
      redirect_to setup_first_project_path
    else
      render :index
    end
  end
  # End Multisite Setup

  # Single site setup
  def first_time_user
    @user = User.new
  end

  def create_first_user
    @user = User.new(user_params)

    if @user.save
      current_team.team_users.create!(user: @user, role: "owner")
      sign_in @user

      redirect_to setup_first_project_path
    else
      render :first_time_user
    end
  end
  # End single site setup

  def first_project
    @project = Project.new
  end

  def create_project
    @project = current_user.created_projects.build(project_params)

    if @project.save
      @project.users << current_user

      redirect_to setup_invite_team_path
    else
      render :first_project
    end
  end

  def invite_team
    @team_invites = TeamInvitesForm.new(current_team, current_user)
  end

  def send_invites
    @team_invites = TeamInvitesForm.new(current_team, current_user, project_ids: current_team.project_ids)

    if @team_invites.submit(invite_params)
      flash[:notice] = "Your team members have been invited!"
      redirect_to project_path(Project.first)
    else
      render :invite_team
    end
  end

  private

  def ensure_single_site_install
    redirect_to root_url if multisite_install?
  end

  def ensure_no_users
    redirect_to root_url if current_team.users.count > 0
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :avatar)
  end

  def project_params
    params.require(:project).permit(:name)
  end

  def invite_params
    params.require(:team_invites_form).permit(:members)
  end
end
