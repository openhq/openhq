module Api
  module V1
    class UserController < BaseController
      def show
        render json: current_user, serializer: CurrentUserSerializer, root: :user
      end

      def create
        # TODO
      end

      def update
        # TODO
      end

      def destroy
        # TODO
      end
    end
  end
end
