redis_settings = {
  namespace: "openhq_sidekiq",
  url: Rails.application.secrets.redis_url,
  network_timeout: 3
}

Sidekiq.configure_server do |config|
  config.redis = redis_settings
end

Sidekiq.configure_client do |config|
  config.redis = redis_settings
end
