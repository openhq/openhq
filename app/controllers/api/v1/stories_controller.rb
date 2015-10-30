module Api
  module V1
    class StoriesController < BaseController
      before_action :set_project, only: [:index, :create]

      resource_description do
        formats ["json"]
      end

      def_param_group :story do
        param :project, Hash, desc: "Project info" do
          param :name, String, desc: "Project name", required: true
          param :user_ids, Array, of: Integer, desc: "Users to add to the project", required: false
        end
      end

      api! "Fetch all stories"
      param :project_id, String, desc: "Project ID or slug", required: true
      def index
        render json: @project.stories.includes(:owner, :project, :comments, :tasks)
      end

      api! "Fetch a single story"
      def show
        story = Story.friendly.find(params[:id])
        render json: story
      end

      api! "Create a new story"
      param :project_id, String, desc: "Project ID or slug", required: true
      param_group :story
      def create
        story = current_user.stories.build(story_params)
        authorize! :create, story

        story.project = @project
        if story.save
          notify(story, %w(created mentioned))
          render json: story, status: 201
        else
          render_errors(story)
        end
      end

      api! "Update a story"
      param_group :story
      def update
        story = current_user.stories.friendly.find(params[:id])
        authorize! :update, story

        if story.update(story_params)
          render json: story
        else
          render_errors(story)
        end
      end

      api! "Delete a new story"
      def destroy
        story = current_user.stories.friendly.find(params[:id])
        authorize! :destroy, story

        story.destroy
        render nothing: true, status: 204
      end

      private

      def set_project
        @project = current_team.projects.friendly.find(params[:project_id])
        authorize! :read, @project
      end

      def story_params
        params.require(:story).permit(:name, :description)
      end
    end
  end
end
