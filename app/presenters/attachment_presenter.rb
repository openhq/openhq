class AttachmentPresenter < BasePresenter
  presents :attachment

  def thumbnail(size)
    attachment.process_data["thumbnail:#{size.to_s}"]
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
