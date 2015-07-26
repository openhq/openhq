require 'tempfile'
require 'securerandom'
require 'rmagick'
require 's3_uploader'

module AttachmentProcessor
  class Image
    attr_reader :attachment, :ext, :original_img, :resize_img

    def initialize(attachment)
      @attachment = attachment
      @ext = ".#{attachment.extension}"
      @original_img = Tempfile.new([SecureRandom.hex(18), ext])
      @resize_img = Tempfile.new([SecureRandom.hex(18), ext])

      open(attachment.url) do |file|
        original_img.write(file.read.force_encoding("utf-8"))
      end
    end

    def resize_and_upload(width: 600, height: 400, tag: :thumb)
      # resize it
      img = Magick::Image.read(original_img.path).first
      img.resize_to_fill!(width, height)
      img.write(resize_img.path)

      # upload it to s3
      s3_path = attachment.file_path.sub(ext, "-#{String(tag)}#{ext}")
      s3_file = S3Uploader.upload(resize_img.path, s3_path)

      # update the attachment process data json
      attachment.set_process_data("thumbnail:#{String(tag)}", String(s3_file.public_url))
    end

    def close
      original_img.unlink
      resize_img.unlink
    end
  end
end