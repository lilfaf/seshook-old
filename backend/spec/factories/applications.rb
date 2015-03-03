FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    name         { Faker::Name.name }
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
  end
end
