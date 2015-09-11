module Settings
  class PasswordsController < ApplicationController
    def show
    end

    def create
      if current_user.update_with_password(user_params)
        redirect_to settings_password_path, notice: "Your password has been changed"
      else
        render :show
      end
    end

    private

    def user_params
      params.require(:user).permit(:current_password, :password)
    end
  end
end
