FactoryGirl.define do
  factory :spot do
    sequence(:name) { |n| "test name #{n}" }
    latitude        { rand(-90.0..90.0) }
    longitude       { rand(-180.0..180.0) }

    after(:build) do |spot|
      spot.address = create(:address)
    end
  end

  factory :spot_with_upload, parent: :spot do
    after(:build) { |s| s.new_photo_uploads_uuids = [create(:photo_upload).uuid] }
  end

  factory :spot_with_album, parent: :spot do
    after(:build) { |s| s.albums << create(:album) }
  end

  factory :spot_with_photo, parent: :spot do
    after(:build) { |s| s.photos << create(:photo) }
  end

  factory :spot_with_author, parent: :spot do
    after(:build) { |s| s.user = create(:user) }
  end
end
