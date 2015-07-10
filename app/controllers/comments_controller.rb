class CommentsController < ApplicationController
  before_action :set_project
  before_action :set_story
  before_action :set_comment, except: :create

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

      NotificationService.new(@comment, 'created').notify

      redirect_to :back, notice: "Your comment has been added"
    else
      flash[:error] = get_first_error(@comment)
      redirect_to :back
    end
  end

  def edit
    authorize! :update, @comment
  end

  def update
    authorize! :update, @comment
    if @comment.update(comment_params)
      flash[:notice] = "Comment updated"
      redirect_to project_story_path(@project, @story)
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @comment
    @comment.destroy
    flash[:notice] = "Comment deleted"
    redirect_to project_story_path(@project, @story)
  end

  private

  def set_project
    @project = Project.friendly.find(params[:project_id])
  end

  def set_story
    @story = @project.stories.friendly.find(params[:story_id])
  end

  def set_comment
    @comment = @story.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :attachment_ids)
  end

end
