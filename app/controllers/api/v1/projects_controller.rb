module Api
  module V1
    class ProjectsController < BaseController
      def index
        render json: current_user.projects.all
      end
    end
  end
end
