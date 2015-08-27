class AttachmentPresenter < BasePresenter
  presents :attachment

  delegate :story, to: :attachment
  delegate :project, to: :story

  def thumbnail(size)
    url = attachment.process_data["thumbnail:#{String(size)}"]
    S3UrlSigner.sign(url) if url.present?
  end

  def icon_name
    case attachment.extension
    when "css", "html", "js", "doc", "mkv", "mp3", "pdf", "png", "jpg", "gif", "psd", "rar", "zip", "txt"
      attachment.extension
    when "docx"
      "doc"
    when "jpeg"
      "jpg"
    else
      "generic"
    end
  end
end
