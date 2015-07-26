require "attachment_processors/image"

class ProcessAttachmentJob < ActiveJob::Base
  queue_as :default

  def perform(attachment)
    if attachment.image?
      processor = AttachmentProcessor::Image.new(attachment)
      processor.resize_and_upload(width: 600, height: 400, tag: "thumb")
    end
  end
end