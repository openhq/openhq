require "attachment_processors/image"
require "attachment_processors/null_processor"

class ProcessAttachmentJob < ActiveJob::Base
  queue_as :default
  MAX_ATTEMPTS = 5

  def perform(attachment)
    processor_for(attachment).process(attachment)

    attachment.processed_at = Time.zone.now
    attachment.save!

  # If the processing fails, increment the process attempts
  #
  # if it fails the max number of times, do not raise the exception.
  # This will stop sidekiq from placing it in the retries pile
  rescue StandardError => e
    attachment.process_attempts += 1
    attachment.save

    raise e if attachment.process_attempts < MAX_ATTEMPTS
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