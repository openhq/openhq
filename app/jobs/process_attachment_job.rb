class ProcessAttachmentJob < ActiveJob::Base
  queue_as :default

  def perform(attachment)
    if attachment.image?
      # download the image to tmp
      # resize it and upload to s3
      # save url in attachment
    end
  end
end