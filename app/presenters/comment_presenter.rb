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
    when "mentioned"
      mentioned_users(comment.content)
    end
  end

end