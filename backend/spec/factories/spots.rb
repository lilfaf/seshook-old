FactoryGirl.define do
  factory :spot do
    sequence(:name) { |n| "test name #{n}" }
    latitude        { rand(-90.0..90.0) }
    longitude       { rand(-180.0..180.0) }
  end

  factory :spot_with_upload, parent: :spot do
    after(:build) { |s| s.new_photo_uploads_uuids = [create(:photo_upload).uuid] }
  end
end
