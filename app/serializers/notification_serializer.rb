class NotificationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :notifiable, :notifiable_type, :action_performed, :seen, :link_to

  has_one :actioner, serializer: UserSerializer
  has_one :team, serializer: TeamSerializer
  has_one :story, serializer: StorySerializer
  has_one :project, serializer: ProjectSerializer

  def action_performed
    "#{object.notifiable_type}_#{object.action_performed}".try(:downcase)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def link_to
    case object.notifiable_type
    when "Project"
      api_v1_project_path(project)
    when "Story"
      api_v1_story_path(story)
    when "Task"
      api_v1_task_path(object.notifiable)
    when "Comment"
      api_v1_comment_path(object.notifiable)
    when "Attachment"
      api_v1_attachment_path(object.notifiable)
    end

  # If a story or project has been archived...
  rescue ActionController::UrlGenerationError
    nil
  end
end
