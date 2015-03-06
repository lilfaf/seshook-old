FactoryGirl.define do
  factory :album do
    name { Faker::Name.name }
  end

  factory :album_with_photo, parent: :album do
    after(:build) do |album|
      album.photos << create(:photo)
    end
  end

  factory :album_with_upload, parent: :album do
    after(:build) { |a| a.new_photo_uploads_uuids = [create(:photo_upload).uuid] }
  end
end
