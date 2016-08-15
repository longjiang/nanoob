if Rails.env.production?
  require "refile/s3"
  aws = {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'], 
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], 
    bucket: ENV['AWS_BUCKET'],
    region: ENV['AWS_REGION']
  } 
  Refile.cache = Refile::S3.new(prefix: "cache", **aws)
  Refile.store = Refile::S3.new(prefix: "store", **aws)
end