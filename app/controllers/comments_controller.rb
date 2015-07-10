class CommentsController < ApplicationController

  def create
    @comment = Comment.new(
      commentable: Story.friendly.find(params[:story_id]),
      owner: current_user,
      content: comment_params[:content]
    )

    if @comment.save
      attachment_ids = comment_params[:attachment_ids].split(',')
      if attachment_ids.any?
        Attachment.where("id IN (?)", attachment_ids).each { |a| a.attach_to(@comment) }
      end

      notify(@comment, %w(created mentioned))

      redirect_to :back, notice: "Your comment has been added"
    else
      flash[:error] = get_first_error(@comment)
      redirect_to :back
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :attachment_ids)
  end

end
