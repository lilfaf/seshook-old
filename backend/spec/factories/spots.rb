FactoryGirl.define do
  factory :spot do
    sequence(:name) { |n| "test name #{n}" }
    latitude        { rand(-90.0..90.0) }
    longitude       { rand(-180.0..180.0) }
  end
end
