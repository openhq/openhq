require 'tempfile'
require 'securerandom'
require 'rmagick'
require 's3_uploader'

module AttachmentProcessor
  class Image
    attr_reader :attachment, :ext

    def self.process(attachment)
      processor = new(attachment)
      attachment.thumbnail_sizes.each do |tag, dimensions|
        processor.resize_and_upload(width: dimensions[0], height: dimensions[1], tag: tag)
      end
    end

    def initialize(attachment)
      @attachment = attachment
      @ext = ".#{attachment.extension}"
    end

    def resize_and_upload(width: 600, height: 400, tag: :thumb)
      # create a tmp file to write the resized image to
      tmp_img = Tempfile.new([SecureRandom.hex(18), ext])

      # resize it
      img = Magick::Image.read(attachment.url).first
      img.resize_to_fill!(width, height)
      img.write(tmp_img.path)

      # upload it to s3
      s3_path = attachment.file_path.sub(ext, "-#{String(tag)}#{ext}")
      S3Uploader.upload(tmp_img.path, s3_path)

      # update the attachment process data json
      attachment.set_process_data("thumbnail:#{String(tag)}", s3_path)

      # delete the tmp image
      tmp_img.unlink
    end
  end
end