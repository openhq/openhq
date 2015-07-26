require 'aws-sdk'

class S3Uploader
  def self.upload(file, path)
    s3_file = s3_bucket.objects[path].write(file: file)
    s3_file.acl = :public_read

    s3_file
  end

  def self.s3_bucket
    bucket = s3.buckets[ENV['AWS_S3_BUCKET']]
    bucket.acl = :public_read

    bucket
  end

  def self.s3
    @s3 ||= AWS::S3.new(access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
  end
end