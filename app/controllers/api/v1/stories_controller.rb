module Api
  module V1
    class StoriesController < BaseController
      before_action :set_project

      resource_description do
        formats ["json"]
      end

      api! "Fetch all stories"
      def index
        render json: @project.stories.includes(:owner)
      end

      api! "Fetch a single story"
      def show
        story = @project.stories.friendly.find(params[:id])
        render json: story
      end

      api! "Create a new story"
      param :story, Hash, desc: "Story info" do
        param :name, String, desc: "Story name", required: true
        param :description, String, desc: "Description of the story (displayed like a discussion)", required: false
      end
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
      param :story, Hash, desc: "Story info" do
        param :name, String, desc: "Story name", required: true
        param :description, String, desc: "Description of the story (displayed like a discussion)", required: false
      end
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
