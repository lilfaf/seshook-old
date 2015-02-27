CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:                ENV.fetch('AWS_REGION', 'us-west-2'),
  }
  config.fog_directory = ENV.fetch('S3_BUCKET', "seshook-#{Rails.env}")
  config.fog_public = false
end

