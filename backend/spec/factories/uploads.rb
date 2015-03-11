FactoryGirl.define do
  factory :upload, class: 'S3Relay::Upload' do
    uuid         SecureRandom.uuid
    filename     'logo.png'
    content_type 'image/png'
    upload_type  'FileUpload'
  end

  factory :photo_upload, parent: :upload do
    upload_type 'PhotoUpload'
  end

  factory :avatar_upload, parent: :upload do
    upload_type 'AvatarUpload'
  end
end
