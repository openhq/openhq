S3DirectUpload.config do |c|
  c.access_key_id = ENV['AWS_ACCESS_KEY_ID']
  c.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  c.bucket = ENV['AWS_S3_BUCKET']
  c.region = ENV['AWS_S3_REGION'] || nil
  c.url = nil                # S3 API endpoint (optional), eg. "https://#{c.bucket}.s3.amazonaws.com/"
end
