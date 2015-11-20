module Api
  module V1
    class UserController < BaseController
      resource_description do
        short "Get information about the current user"
        formats ["json"]
      end

      api! "Fetch the current user"
      def show
        render json: current_user, serializer: CurrentUserSerializer, root: :user
      end

      def create
        # TODO
      end

      api! "Update the current user"
      param :user, Hash, desc: "User info" do
        param :first_name, String, desc: "First Name", required: true
        param :last_name, String, desc: "Last Name", required: true
        param :username, String, desc: "Username", required: true
        param :email, String, desc: "Email Address", required: true
        param :notification_frequency, String, desc: "Notification Frequency", required: true
        param :avatar, String, desc: "Users Avatar", required: false
        param :job_title, String, desc: "Job Title", required: false
        param :phone, String, desc: "Phone number", required: false
        param :skype, String, desc: "Skype username", required: false
        param :bio, String, desc: "Biography for the user", required: false
        param :current_password, String, desc: "The users current password", required: true
      end
      def update
        if current_user.update_with_password(user_params)
          render json: current_user, serializer: CurrentUserSerializer, root: :user
        else
          render_errors(current_user)
        end
      end

      api! "Update the current users password"
      param :user, Hash, desc: "User info" do
        param :current_password, String, desc: "The users current password", required: true
        param :password, String, desc: "The new password", required: true
      end
      def password
        current_user.password_changing = true

        if current_user.update_with_password(password_params)
          UserMailer.password_changed(current_user).deliver_later
          render json: current_user, serializer: CurrentUserSerializer, root: :user
        else
          render_errors(current_user)
        end
      end

      api! "Delete the users account"
      param :current_password, String, desc: "The users current password", required: true
      def destroy
        if current_user.authenticated?(params[:current_password])
          current_user.update(deleted_at: Time.zone.now)
          sign_out

          render json: current_user, serializer: CurrentUserSerializer, root: :user
        else
          render_errors(current_user)
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :username, :email,
          :notification_frequency, :avatar,
          :job_title, :phone, :skype, :bio, :current_password)
      end

      def password_params
        params.require(:user).permit(:current_password, :password)
      end
    end
  end
end
