class NotificationSerializer < ActiveModel::Serializer
  attributes :action_performed, :notifiable_type, :notifiable_id, :notifiable, :story_name, :owner_name, :owner_avatar_url, :link_to

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

  def story_name
    case notifiable_type
    when "Project"
      ""
    when "Story"
      notifiable.name
    when "Task"
      notifiable.story.name
    when "Comment"
      notifiable.commentable.name
    end
  end

  def link_to
    case notifiable_type
    when "Project"
      project_path(notifiable)
    when "Story"
      project_story_path(notifiable.project, notifiable)
    when "Task"
      project_story_path(notifiable.story.project, notifiable.story) + "#task:#{notifiable_id}"
    when "Comment"
      project_story_path(notifiable.commentable.project, notifiable.commentable) + "#comment:#{notifiable_id}"
    end
  end
end