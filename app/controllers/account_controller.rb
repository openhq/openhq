class AccountController < ApplicationController
  def edit
  end

  def update
    if current_user.update_with_password(user_params)
      redirect_to "/", notice: "Account updated."
    else
      render :edit
    end
  end

  def destroy
    current_user.destroy
    sign_out :user
    flash[:notice] = "Your account has been deleted"
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :notification_frequency,
      :password, :password_confirmation, :current_password)
  end
end
