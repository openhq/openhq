module Api
  module V1
    class CommentsController < BaseController
      before_action :set_story

      def index
        comments = @story.comments.includes(:owner).all
        render json: comments
      end

      def show
        comment = @story.comments.find(params[:id])
        render json: comment
      end

      def create
        comment = Comment.new(
          commentable: @story,
          owner: current_user,
          content: comment_params[:content]
        )

        if comment.save
          attachment_ids = String(comment_params[:attachment_ids]).split(',')
          if attachment_ids.any?
            Attachment.where("id IN (?)", attachment_ids).each { |a| a.attach_to(comment) }
          end

          notify(comment, %w(created mentioned))

          render json: comment, status: 201
        else
          render_errors(comment)
        end
      end

      def update
        comment = @story.comments.find(params[:id])
        authorize! :update, comment
        if comment.update(comment_params)
          render json: comment
        else
          render_errors(comment)
        end
      end

      def destroy
        comment = @story.comments.find(params[:id])
        authorize! :destroy, comment
        comment.destroy
        render nothing: true, status: 204
      end

      private

      def set_story
        @project = current_team.projects.friendly.find(params[:project_id])
        @story = @project.stories.friendly.find(params[:story_id])

        authorize! :read, @project
      end

      def comment_params
        params.require(:comment).permit(:content, :attachment_ids)
      end
    end
  end
end
