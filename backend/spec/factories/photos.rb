FactoryGirl.define do
  factory :photo do
    file         { File.open('spec/fixtures/logo.png') }
    size         { '123456' }
    content_type { 'image/png' }
  end
end
