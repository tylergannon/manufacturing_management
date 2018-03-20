# frozen_string_literal: true
Rails.application.config.x.redis_server_url = ENV['REDISCLOUD_URL']

Sidekiq.configure_server do |config|
  config.redis = { url: Rails.application.config.x.redis_server_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Rails.application.config.x.redis_server_url }
end
