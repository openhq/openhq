class CommentPresenter < BasePresenter
  presents :comment

  delegate :project, to: :story

  def story
    comment.commentable
  end

  def notifiable_users(action_performed)
    case action_performed
    when "created"
      story.collaborators.where("users.id != :id", id: comment.owner_id)
    end
  end

end