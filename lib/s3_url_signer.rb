class S3UrlSigner
  def self.sign(path)
    s3 = AWS::S3.new(region: ENV["AWS_S3_REGION"])
    bucket = s3.buckets[ENV["AWS_S3_BUCKET"]]
    obj = bucket.objects[path]
    obj.url_for(:get, expires: 3600).to_s
  end
end
