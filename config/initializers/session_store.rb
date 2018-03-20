# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

if ENV['REDISCLOUD_URL']
  Rails.application.config.session_store :redis_store, servers: ENV['REDISCLOUD_URL']
else
  Rails.application.config.session_store :redis_store, nil
end
