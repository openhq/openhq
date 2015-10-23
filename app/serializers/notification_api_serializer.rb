class NotificationApiSerializer < ActiveModel::Serializer
  attributes :id, :notifiable_type, :notifiable, :action_performed, :seen, :actioner, :project, :story, :team, :link_to

  has_one :actioner, serializer: UserSerializer
  has_one :team, serializer: TeamSerializer
  has_one :story, serializer: StorySerializer
  has_one :project, serializer: ProjectSerializer

  def link_to
    case notifiable_type
    when "Project"
      api_v1_project_path(project)
    when "Story"
      api_v1_project_story_path(project, story)
    when "Task"
      api_v1_project_story_task_path(project, story, notifiable)
    when "Comment"
      api_v1_project_story_comment_path(project, story, notifiable)
    when "Attachment"
      api_v1_project_story_attachment_path(project, story, notifiable)
    end

  # If a story or project has been archived...
  rescue ActionController::UrlGenerationError
    nil
  end
end