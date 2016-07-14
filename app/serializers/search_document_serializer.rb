class SearchDocumentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :searchable_id, :searchable_type, :searchable, :url, :project, :project_url, :story, :story_url, :attachment_image

  def project_url
    project.present? ? project_path(project) : nil
  end

  def story_url
    story.present? ? project_story_path(project, story) : nil
  end

  def url
    case object.searchable_type
    when "Project"
      project_path(object.searchable)
    when "Story"
      project_story_path(object.project, object.searchable)
    when "Task"
      project_story_path(object.project, object.story) + "#task:#{object.searchable_id}"
    when "Comment"
      project_story_path(object.project, object.story) + "#comment:#{object.searchable_id}"
    when "Attachment"
      project_story_path(object.project, object.story) + "#attachment:#{object.searchable_id}"
    end
  end

  def attachment_image
    return unless object.searchable_type == "Attachment"

    image_url = object.searchable.process_data["thumbnail:tile"]
    if image_url.present?
      S3UrlSigner.sign(image_url)
    else
      "/assets/file_types/#{object.searchable.extension}.png"
    end
  end
end
