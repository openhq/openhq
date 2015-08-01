require 'aws-sdk'

class S3Uploader
  attr_reader :file, :path, :options, :s3_file

  def self.upload(file, path, options = {})
    uploader = new(file, path, options)
    uploader.upload
    uploader
  end

  def initialize(file, path, options = {})
    @file = file
    @path = path
    @options = options
  end

  def upload
    @s3_file = s3.buckets[ENV['AWS_S3_BUCKET']].objects[path].write(file: file)
  end

  private

  def s3
    @s3 ||= AWS::S3.new(access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
  end
end