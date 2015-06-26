redis_settings = {
  namespace: "openhq_sidekiq",
  url: ENV.fetch('REDISCLOUD_URL', 'redis://127.0.0.1:6379'),
  network_timeout: 3
}

Sidekiq.configure_server do |config|
  config.redis = redis_settings
end

Sidekiq.configure_client do |config|
  config.redis = redis_settings
end
