class AttachmentThumbnailJob < ActiveJob::Base
  queue_as :default

  def perform(attachment)

  end
end