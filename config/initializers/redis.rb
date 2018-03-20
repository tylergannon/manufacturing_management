# frozen_string_literal: true
$redis = Redis.new(url: ENV['REDISCLOUD_URL']) if ENV['REDISCLOUD_URL']
