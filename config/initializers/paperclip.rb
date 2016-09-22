Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_host_name] = ENV['AWS_S3_HOST'] || nil
Paperclip::Attachment.default_options[:s3_protocol] = :https
Paperclip::Attachment.default_options[:s3_region] = ENV['AWS_S3_REGION']
Paperclip::Attachment.default_options[:s3_credentials] = {
  bucket: ENV.fetch('AWS_S3_BUCKET'),
  access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
}