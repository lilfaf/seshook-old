FactoryGirl.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              { 'seshook123' }
    password_confirmation { 'seshook123' }
  end

  factory :admin, parent: :user do
    after(:build) { |u| u.admin! }
  end

  factory :superadmin, parent: :user do
    after(:build) { |u| u.superadmin! }
  end
end

