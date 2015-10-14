class NotificationSerializer < ActiveModel::Serializer
  attributes :notifiable_type, :notifiable_id, :action_performed, :seen, :actioner, :project, :story, :team, :actioner_name, :actioner_avatar_url, :link_to

  def actioner_name
    actioner.display_name
  end

  def actioner_avatar_url
    if actioner.avatar_file_name.present?
      actioner.avatar.url(:thumb)
    else
      gravatar_url(60)
    end
  end

  def gravatar_url(size)
    base_url = "https://www.gravatar.com/avatar/"
    opts = "?d=blank&s="

    hash = Digest::MD5.hexdigest(actioner.email)

    base_url + hash + opts + size.to_s
  end

  def link_to
    case notifiable_type
    when "Project"
      project_path(project)
    when "Story"
      project_story_path(project, story)
    when "Task"
      project_story_path(project, story) + "#task:#{notifiable_id}"
    when "Comment"
      project_story_path(project, story) + "#comment:#{notifiable_id}"
    end

  rescue ActionController::UrlGenerationError
    "#"
  end
end