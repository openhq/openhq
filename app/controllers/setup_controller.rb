class SetupController < ApplicationController
  before_action :ensure_fresh_install, except: :complete
  skip_before_action :authenticate_user!, only: [:new, :create]

  layout "setup"

  def new
    @admin = User.new
  end

  def create
    @admin = User.new(admin_user_params.merge(role: "owner"))

    if @admin.save
      sign_in :user, @admin

      redirect_to setup_complete_path
    else
      render :new
    end
  end

  def complete
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
end
