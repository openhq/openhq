class SearchDocumentSerializer < ActiveModel::Serializer
  attributes :searchable_id, :searchable_type, :searchable, :project, :story, :url, :attachment_image

  def url
    case searchable_type
    when "Project"
      project_path(searchable)
    when "Story"
      project_story_path(project, searchable)
    when "Task"
      project_story_path(project, story) + "#task:#{searchable_id}"
    when "Comment"
      project_story_path(project, story) + "#comment:#{searchable_id}"
    when "Attachment"
      project_story_path(project, story) + "#attachment:#{searchable_id}"
    end
  end

  def attachment_image
    return unless searchable_type == "Attachment"

    image_url = searchable.process_data["thumbnail:tile"]
    if image_url.present?
      S3UrlSigner.sign(image_url)
    else
      "/assets/file_types/#{searchable.extension}.png"
    end
  end
end