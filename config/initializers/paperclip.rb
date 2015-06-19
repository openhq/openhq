Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_host_name] = ENV['AWS_S3_HOST'] || nil
Paperclip::Attachment.default_options[:s3_protocol] = :https
Paperclip::Attachment.default_options[:s3_credentials] = {
  bucket: ENV['AWS_S3_BUCKET'],
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
}
