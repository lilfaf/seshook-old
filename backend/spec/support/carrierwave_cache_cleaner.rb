RSpec.configure do |config|
  config.after(:all) do
    FileUtils.rm_rf(Dir[Rails.root.join('public/uploads')])
  end
end
