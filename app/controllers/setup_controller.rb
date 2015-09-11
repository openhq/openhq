class SetupController < ApplicationController
  before_action :ensure_fresh_install, except: [:initial_setup, :complete]
  before_action :ensure_owner, only: [:initial_setup, :complete]
  skip_before_action :require_login, only: [:new, :create]

  layout "setup"

  def new
    @admin = User.new
  end

  def create
    @admin = User.new(admin_user_params)

    if @admin.save
      current_team.team_users.create!(user: @admin, role: "owner")

      sign_in @admin

      redirect_to initial_setup_path
    else
      render :new
    end
  end

  def initial_setup
    @initial_setup = InitialSetupForm.new(current_user, current_team)
  end

  def complete
    @initial_setup = InitialSetupForm.new(current_user, current_team)

    if @initial_setup.submit(initial_setup_params)
      redirect_to root_url, notice: "Setup complete!"
    else
      render :initial_setup
    end
  end

  private

  def ensure_fresh_install
    if User.any?
      flash[:error] = "This install has already been setup"
      redirect_to root_url
    end
  end

  def admin_user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
  end

  def initial_setup_params
    params.require(:initial_setup_form).permit(:project_name, :team_members)
  end
end
