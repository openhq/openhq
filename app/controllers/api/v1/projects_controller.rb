module Api
  module V1
    class ProjectsController < BaseController
      def index
        render json: current_user.projects.all
      end

      def show
        project = current_user.projects.friendly.find(params[:id])
        render json: project, root: :project
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

      def update
        project = current_user.projects.friendly.find(params[:id])
        authorize! :update, project

        if project.update(project_params)
          # TODO bugfix:
          # after updating a project params[:user_ids] won’t include
          # the current_user anymore
          project.users << current_user unless project.users.exists?(current_user.id)
          render json: project, root: :project
        else
          render_errors(project)
        end
      end

      def destroy
        project = current_user.projects.friendly.find(params[:id])
        authorize! :destroy, project

        project.destroy

        render nothing: true, status: 204
      end

      private

      def project_params
        params.require(:project).permit(:name, user_ids: [])
      end
    end
  end
end
