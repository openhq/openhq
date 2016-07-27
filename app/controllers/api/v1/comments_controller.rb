module Api
  module V1
    class CommentsController < BaseController
      def_param_group :comment do
        param :comment, Hash, desc: "Comment info" do
          param :content, String, desc: "Comment body", required: true
          param :attachment_ids, Array, of: Integer, desc: "Array of attachment ids to attach to the comment", required: false
        end
      end

      api! "Fetch all comments"
      param :story_id, String, desc: "Story ID or slug", required: true
      def index
        story = Story.friendly.find(params[:story_id])
        comments = story.comments.includes(:owner).all
        render json: comments
      end

      api! "Fetch a single comment"
      def show
        comment = Comment.find(params[:id])
        render json: comment
      end

      api! "Create new comment"
      param_group :comment
      param :"comment[story_id]", String, desc: "Story ID or slug", required: true
      def create
        commentable = comment_params[:commentable_type].constantize.find(comment_params[:commentable_id])
        authorize! :read, commentable.project

        comment = Comment.new(
          commentable: commentable,
          owner: current_user,
          content: comment_params[:content]
        )

        if comment.save
          attachment_ids = String(comment_params[:attachment_ids]).split(',')

          if attachment_ids.any?
            Attachment.where("id IN (?)", attachment_ids).each { |a| a.attach_to(comment) }
          end

          # notify(comment, %w(created mentioned))

          render json: comment, status: 201
        else
          render_errors(comment)
        end
      end

      api! "Update comment"
      param_group :comment
      def update
        comment = Comment.find(params[:id])
        authorize! :update, comment
        if comment.update(comment_params)
          render json: comment
        else
          render_errors(comment)
        end
      end

      api! "Delete a comment"
      def destroy
        comment = Comment.find(params[:id])
        authorize! :destroy, comment
        comment.destroy
        head :no_content
      end

      private

      def comment_params
        params.require(:comment).permit(:content, :attachment_ids, :commentable_type, :commentable_id)
      end
    end
  end
end
