class SearchDocumentApiSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :searchable_id, :searchable_type, :searchable, :url, :project, :project_url, :story, :story_url, :attachment_image

  def project_url
    project.present? ? api_v1_project_path(project) : nil
  end

  def story_url
    story.present? ? api_v1_story_path(story) : nil
  end

  def url
    case searchable_type
    when "Project"
      api_v1_project_path(searchable)
    when "Story"
      api_v1_story_path(searchable)
    when "Task"
      api_v1_task_path(searchable)
    when "Comment"
      api_v1_comment_path(searchable)
    when "Attachment"
      api_v1_attachment_path(searchable)
    end
  end

  def attachment_image
    return unless searchable_type == "Attachment"

    thumb_url = searchable.process_data["thumbnail:tile"]

    if thumb_url.present?
      S3UrlSigner.sign(thumb_url)
    else
      ActionController::Base.helpers.image_url "file_types/#{searchable.icon_name}.png"
    end
  end
end
