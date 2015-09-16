class SignupsController < ApplicationController
  skip_before_action :require_login

  def new
    @signup = SignupForm.new
  end

  def create
    @signup = SignupForm.new

    if @signup.submit(signup_params)
      redirect_to success_signups_path
    else
      render :new
    end
  end

  def success
  end

  private

  def signup_params
    params.require(:signup_form).permit(:team_name, :subdomain, :email)
  end
end
