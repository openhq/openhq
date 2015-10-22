class SearchDocumentApiSerializer < ActiveModel::Serializer
  attributes :searchable_id, :searchable_type, :searchable, :url, :project, :project_url, :story, :story_url, :attachment_image

  def project_url
    project.present? ? api_v1_project_path(project) : nil
  end

  def story_url
    story.present? ? api_v1_project_story_path(project, story) : nil
  end

  def url
    case searchable_type
    when "Project"
      api_v1_project_path(searchable)
    when "Story"
      api_v1_project_story_path(project, searchable)
    when "Task"
      api_v1_project_story_task_path(project, story, searchable)
    when "Comment"
      api_v1_project_story_comment_path(project, story, searchable)
    when "Attachment"
      api_v1_project_story_attachment_path(project, story, searchable)
    end
  end

  def attachment_image
    return unless searchable_type == "Attachment"

    image_url = searchable.process_data["thumbnail:tile"]
    S3UrlSigner.sign(image_url) if image_url.present?
  end
end