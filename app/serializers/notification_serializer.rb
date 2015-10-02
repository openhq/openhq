class NotificationSerializer < ActiveModel::Serializer
  attributes :notifiable_type, :notifiable_id, :notifiable, :action_performed, :project, :story, :team, :owner_name, :owner_avatar_url, :link_to

  def owner
    notifiable.owner
  end

  def owner_name
    owner.display_name
  end

  def owner_avatar_url
    if owner.avatar_file_name.present?
      owner.avatar.url(:thumb)
    else
      gravatar_url(60)
    end
  end

  def gravatar_url(size)
    base_url = "https://www.gravatar.com/avatar/"
    opts = "?d=blank&s="

    hash = Digest::MD5.hexdigest(owner.email)

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
  end
end