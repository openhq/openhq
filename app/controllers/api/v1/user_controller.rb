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
      def update
        if current_user.update_with_password(user_params)
          render json: current_user, serializer: CurrentUserSerializer, root: :user
        else
          render_errors(current_user)
        end
      end

      api! "Update the current users password"
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
      def destroy
        if current_user.authenticated?(params[:current_password])
          current_user.update(deleted_at: Time.zone.now)

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
