module Setup
  class MultisiteController < ApplicationController
    layout "setup"
    skip_before_action :require_login
    skip_before_action :run_first_time_setup

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

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :avatar)
    end
  end
end
