class CommentsController < ApplicationController

  def create
    @comment = Comment.new(
      commentable: Story.friendly.find(params[:story_id]),
      owner: current_user,
      content: comment_params[:content]
    )

    if @comment.save
      redirect_to :back, notice: "Your comment has been added"
    else
      flash[:error] = "There was an error adding your comment"
      redirect_to :back
    end
  end

private

  def comment_params
    params.require(:comment).permit(:content)
  end

end