FactoryGirl.define do
  factory :address do
    street        { Faker::Address.street_address }
    city          { Faker::Address.city }
    zip           { Faker::Address.zip_code }
    state         { Faker::Address.state }
    country_code  { Faker::Address.country_code }
  end
end
