module Api
  module V1
    class ProjectsController < BaseController
      resource_description do
        formats ["json"]
      end

      def_param_group :project do
        param :project, Hash, desc: "Project info" do
          param :name, String, desc: "Project name", required: true
          param :user_ids, Array, of: Integer, desc: "Users to add to the project", required: false
        end
      end

      api! "Fetch all projects"
      param :archived, [true, false], desc: "Get the archived projects (default: false)", required: false
      def index
        if params[:archived]
          render json: current_user.projects.only_deleted, each_serializer: ThinProjectSerializer
        else
          render json: current_user.projects.includes(:users, :recent_stories).all
        end
      end

      api! "Fetch a single project"
      def show
        project = current_user.projects.friendly.find(params[:id])
        render json: project
      end

      api! "Create a project"
      param_group :project
      def create
        project = current_user.created_projects.build(project_params)
        authorize! :create, project

        if project.save
          notify(project, 'created')

          project.users << current_user unless project.users.exists?(current_user.id)
          render json: project, status: 201
        else
          render_errors(project)
        end
      end

      api! "Update a project"
      param_group :project
      def update
        project = current_user.projects.friendly.find(params[:id])
        authorize! :update, project

        if project.update(project_params)
          # TODO bugfix:
          # after updating a project params[:user_ids] won’t include
          # the current_user anymore
          project.users << current_user unless project.users.exists?(current_user.id)
          render json: project
        else
          render_errors(project)
        end
      end

      api! "Delete a project"
      def destroy
        project = current_user.projects.friendly.find(params[:id])
        authorize! :destroy, project

        project.destroy

        render nothing: true, status: 204
      end

      api! "Restores a project"
      def restore
        project = current_user.projects.only_deleted.friendly.find(params[:id])
        project.restore

        render json: project
      end

      private

      def project_params
        params.require(:project).permit(:name, user_ids: [])
      end
    end
  end
end
