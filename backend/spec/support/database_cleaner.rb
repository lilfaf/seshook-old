RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, { pre_count: true, reset_ids: true, except: %w(spatial_ref_sys) }
    DatabaseCleaner.clean_with(:truncation, except: %w(spatial_ref_sys))
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
