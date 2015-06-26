class CommentPresenter < BasePresenter
  presents :comment

  def story
    comment.commentable
  end

  def project
    story.project
  end

  def notifiable_users(action_performed)
    collaborator_ids = story.collaborators.map { |u| u[:id] == comment.owner.id ? nil : u[:id] }
    User.where('id IN (?)', collaborator_ids)
  end

end