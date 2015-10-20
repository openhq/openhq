module Api
  module V1
    class UserController < BaseController
      def show
        render json: current_user, root: :user
      end

      def create
      end

      def update
      end

      def destroy
      end
    end
  end
end
