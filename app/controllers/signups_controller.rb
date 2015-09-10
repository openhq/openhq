class SignupsController < ApplicationController
  layout "public"
  skip_before_action :ensure_team!
  skip_before_action :require_login

  def new
    @signup = SignupForm.new
  end

  def create
    @signup = SignupForm.new

    if @signup.submit(signup_params)
      sign_in @signup.user

      redirect_to root_url(subdomain: @signup.team.subdomain)
    else
      render :new
    end
  end

  private

  def signup_params
    params.require(:signup_form).permit(:team_name, :subdomain, :first_name, :last_name, :username, :email, :password)
  end
end
