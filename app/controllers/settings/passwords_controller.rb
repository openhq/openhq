module Settings
  class PasswordsController < ApplicationController
    def show
    end

    def create
      current_user.password_changing = true

      if current_user.update_with_password(user_params)
        UserMailer.password_changed(current_user).deliver_later

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
