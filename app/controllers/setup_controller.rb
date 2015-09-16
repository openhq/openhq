class SetupController < ApplicationController
  layout "setup"
  skip_before_action :require_login

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
