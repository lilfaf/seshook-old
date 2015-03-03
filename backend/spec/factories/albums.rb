FactoryGirl.define do
  factory :album do
    name { Faker::Name.name }
  end

  factory :album_with_photo, parent: :album do
    after(:build) do |album|
      album.photos << create(:photo)
    end
  end
end
