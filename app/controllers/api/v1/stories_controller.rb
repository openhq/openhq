module Api
  module V1
    class StoriesController < BaseController
      before_action :set_project, only: [:index]

      resource_description do
        formats ["json"]
      end

      # TODO - update this
      def_param_group :story do
        param :project, Hash, desc: "Project info" do
          param :name, String, desc: "Project name", required: true
          param :user_ids, Array, of: Integer, desc: "Users to add to the project", required: false
        end
      end

      api! "Fetch all stories"
      param :project_id, String, desc: "Project ID or slug", required: true
      param :archived, [true, false], desc: "Get the archived stories (default: false)", required: false
      def index
        if params[:archived]
          render json: @project.stories.only_deleted, each_serializer: ThinStorySerializer
        else
          render json: @project.stories.includes(:owner, :project, :comments, :tasks).recent
        end
      end

      api! "Fetch a single story"
      def show
        story = Story.includes(:owner, :attachments, :tasks, project: [:users], comments: [:owner, :attachments]).friendly.find(params[:id])
        render json: story
      end

      api! "Get the stories collaborators"
      def collaborators
        story = Story.includes(:owner, comments: [:owner]).friendly.find(params[:id])
        render json: story.collaborators
      end

      api! "Create a new story"
      param :"story[project_id]", String, desc: "Project ID or slug", required: true
      param_group :story
      def create
        project = Project.friendly.find(params[:story][:project_id])
        story = current_user.stories.build(story_params)
        authorize! :create, story

        story.project = project
        if story.save
          add_tasks_to_story(story)
          add_attachments_to_story(story)
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
        head :no_content
      end

      api! "Restore an archived story"
      def restore
        story = current_user.stories.only_deleted.friendly.find(params[:id])
        story.restore

        render json: story
      end

      private

      def set_project
        @project = current_team.projects.friendly.find(params[:project_id])
        authorize! :read, @project
      end

      def story_params
        params.require(:story).permit(:name, :description, :story_type)
      end

      def add_tasks_to_story(story)
        (params[:story][:tasks] || []).each do |task|
          story.tasks.create(
            label: task[:label],
            assigned_to: task[:assigned_to],
            due_at: task[:due_at]
          )
        end
      end

      def add_attachments_to_story(story)
        (params[:story][:attachments] || []).each do |file|
          story.attachments.create(
            owner_id: current_user.id,
            file_name: file[:file_name],
            file_size: file[:file_size],
            content_type: file[:content_type],
            file_path: file[:file_path]
          )
        end
      end
    end
  end
end
