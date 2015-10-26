class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :notifiable_type, :notifiable, :action_performed, :seen, :link_to

  has_one :actioner, serializer: UserSerializer
  has_one :team, serializer: TeamSerializer
  has_one :story, serializer: StorySerializer
  has_one :project, serializer: ProjectSerializer

  # rubocop:disable Metrics/CyclomaticComplexity
  def link_to
    case notifiable_type
    when "Project"
      api_v1_project_path(project)
    when "Story"
      api_v1_story_path(story)
    when "Task"
      api_v1_task_path(notifiable)
    when "Comment"
      api_v1_comment_path(notifiable)
    when "Attachment"
      api_v1_attachment_path(notifiable)
    end

  # If a story or project has been archived...
  rescue ActionController::UrlGenerationError
    nil
  end
end