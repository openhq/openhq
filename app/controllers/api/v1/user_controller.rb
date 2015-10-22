module Api
  module V1
    class UserController < BaseController
      resource_description do
        short "Get information about the current user"
        formats ["json"]
      end

      api :GET, "/v1/user", "Fetch the current user"
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
