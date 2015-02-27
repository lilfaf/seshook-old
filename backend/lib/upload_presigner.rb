class UploadPresigner

  attr_reader :expires, :uuid

  def initialize(options={})
    @expires = options[:expires] || 15.minute
    @uuid    = SecureRandom.uuid
  end

  def data
    { uuid: uuid, url: presigned_url }
  end

  private

  def presigned_url
    Aws::S3::Presigner.new.presigned_url(
      :put_object,
      bucket: bucket,
      key: "#{uuid}/${filename}",
      expires_in: expires
    )
  end

  def bucket
    ENV.fetch('AWS_REGION', "seshook-#{Rails.env}")
  end
end
