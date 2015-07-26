require "attachment_processors/image"

class ProcessAttachmentJob < ActiveJob::Base
  queue_as :default

  def perform(attachment)
    if attachment.image?
      processor = AttachmentProcessor::Image.new(attachment)

      attachment.thumbnail_sizes.each do |tag, dimensions|
        processor.resize_and_upload(width: dimensions[0], height: dimensions[1], tag: tag)
      end

      processor.close
    end
  end
end