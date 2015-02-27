FactoryGirl.define do
  factory :upload do
    uuid         { SecureRandom.uuid }
    filename     { 'logo.png' }
    content_type { 'image/png' }
    upload_type  { 'PhotoUpload' }
  end
end
