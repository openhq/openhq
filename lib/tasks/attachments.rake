namespace :attachments do
  desc "Pick up unprocessed attachments"
  task process_unprocessed: :environment do
    Attachment.where("processed_at IS NULL AND process_attempts < 15").each do |attachment|
      begin
        puts "Processing Attachment/#{attachment.id}"
        ProcessAttachmentJob.perform_now(attachment)
        puts "Processed Attachment/#{attachment.id}"
      rescue => e
        puts "Attachment::#{attachment.id} #{e.message}"
      end
    end
  end
end
