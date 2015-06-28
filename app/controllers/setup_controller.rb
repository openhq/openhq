class SetupController < ApplicationController
  before_action :ensure_fresh_install, except: [:initial_setup, :complete]
  before_action :ensure_owner, only: [:initial_setup, :complete]
  skip_before_action :authenticate_user!, only: [:new, :create]

  layout "setup"

  def new
    @admin = User.new
  end

  def create
    @admin = User.new(admin_user_params.merge(role: "owner"))

    if @admin.save
      sign_in :user, @admin

      redirect_to initial_setup_path
    else
      render :new
    end
  end

  def initial_setup
    @initial_setup = InitialSetupForm.new(current_user)
  end

  def complete
    @initial_setup = InitialSetupForm.new(current_user)

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
