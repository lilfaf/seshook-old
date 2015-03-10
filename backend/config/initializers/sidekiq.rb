if Rails.env.production?
  url = "redis://#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}/12"
  Sidekiq.configure_server do |config|
    config.redis = { url: url }
  end
  Sidekiq.configure_client do |config|
    config.redis = { url: url }
  end
end
