module Settings
  class AccountController < ApplicationController
    def edit
    end

    def update
      if current_user.update_with_password(user_params)
        redirect_to settings_path, notice: "Account updated."
      else
        render :edit
      end
    end

    def delete # confirm destroy page
    end

    def destroy
      if current_user.authenticated?(destroy_params[:current_password])
        current_user.update(deleted_at: Time.zone.now)
        sign_out
        flash[:notice] = "Your account has been deleted"
        redirect_to root_app_url
      else
        current_user.errors.add(:base, "Your password was incorrect")
        render :delete
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :email,
        :notification_frequency, :avatar,
        :job_title, :phone, :skype, :bio, :current_password)
    end

    def destroy_params
      params.require(:user).permit(:current_password)
    end
  end
end
