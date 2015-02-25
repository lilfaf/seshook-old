FactoryGirl.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              { 'seshook123' }
    password_confirmation { 'seshook123' }
  end
end

