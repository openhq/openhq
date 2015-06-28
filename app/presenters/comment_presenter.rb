class CommentPresenter < BasePresenter
  presents :comment

  def story
    comment.commentable
  end

  def project
    story.project
  end

  def notifiable_users(action_performed)
    story.collaborators.where("users.id != :id", id: comment.owner_id)
  end

end