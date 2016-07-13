class SearchDocumentApiSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :searchable_id, :searchable_type, :searchable, :url, :project, :project_url, :story, :story_url, :attachment_image

  def project_url
    object.project.present? ? api_v1_project_path(object.project) : nil
  end

  def story_url
    object.story.present? ? api_v1_story_path(object.story) : nil
  end

  def url
    case object.searchable_type
    when "Project"
      api_v1_project_path(object.searchable)
    when "Story"
      api_v1_story_path(object.searchable)
    when "Task"
      api_v1_task_path(object.searchable)
    when "Comment"
      api_v1_comment_path(object.searchable)
    when "Attachment"
      api_v1_attachment_path(object.searchable)
    end
  end

  def attachment_image
    return unless object.searchable_type == "Attachment"

    thumb_url = object.searchable.process_data["thumbnail:tile"]

    if thumb_url.present?
      S3UrlSigner.sign(thumb_url)
    else
      ActionController::Base.helpers.image_url "file_types/#{object.searchable.icon_name}.png"
    end
  end
end
