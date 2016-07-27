require_dependency 'parsers/mention_parser'

class CommentPresenter < BasePresenter
  presents :comment

  delegate :story, to: :comment
  delegate :project, to: :story

  def notifiable_users(action_performed)
    case action_performed
    when "created"
      story.collaborators.where("users.id != :id", id: comment.owner_id)
    when "mentioned"
      MentionParser.users(comment.content)
    end
  end

end