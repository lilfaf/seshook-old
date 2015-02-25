Fog.mock!

connection = Fog::Storage.new(
  aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region:                ENV['AWS_S3_REGION'],
  provider:              'AWS'
)

directory = connection.directories.create(key: ENV.fetch('S3_BUCKET', "seshook-#{Rails.env}"))
