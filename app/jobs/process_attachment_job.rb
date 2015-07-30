require "attachment_processors/image"

class ProcessAttachmentJob < ActiveJob::Base
  queue_as :default

  def perform(attachment)
    processor_for(attachment).process(attachment)
  end

  private

  def processor_for(attachment)
    case attachment.content_type
    when %r{\Aimage/}
      AttachmentProcessor::Image
    else
      # TODO process other filetypes
      AttachmentProcessor::NullProcessor
    end
  end
end