module Api
  module V1
    class ProjectsController < BaseController
      def index
        render json: current_user.projects.all
      end

      def create
        project = current_user.created_projects.build(project_params)
        authorize! :create, project

        if project.save
          notify(project, 'created')

          project.users << current_user
          render json: project, status: 201, root: :project
        else
          render_errors(project)
        end
      end

      private

      def project_params
        params.require(:project).permit(:name, user_ids: [])
      end
    end
  end
end
