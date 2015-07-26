require 'tempfile'
require 'securerandom'
require 'rmagick'
require 's3_uploader'

module AttachmentProcessor
  class Image
    attr_reader :attachment

    def initialize(attachment)
      @attachment = attachment
    end

    def resize_and_upload(width: 600, height: 400, tag: :thumb)
      # download the image to a tmp file
      ext = ".#{attachment.extension}"
      tmp = Tempfile.new([SecureRandom.hex(18), ext])
      open(attachment.url) do |file|
        tmp.write(file.read.force_encoding("utf-8"))
      end

      # resize it
      img = Magick::Image.read(tmp.path).first
      img.resize_to_fill!(width, height)
      img.write(tmp.path)

      # upload it to s3
      s3_path = attachment.file_path.sub(ext, "-#{tag.to_s}#{ext}")
      s3_file = S3Uploader.upload(tmp.path, s3_path)

      # update attachment
      process_data = attachment.process_data
      process_data['thumbnails'][tag.to_s] = String(s3_file.public_url)
      attachment.update(process_data: process_data)

      # delete tmp file
      tmp.unlink
    end
  end
end