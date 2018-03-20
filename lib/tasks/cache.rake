# frozen_string_literal: true
namespace :cache do
  desc "Clear Rails Cache"
  task clear: :environment do
    Rails.logger.warn 'Clearing Rails Cache'
    Rails.cache.clear()
  end
end
namespace :deploy do
  desc "Create a new deployment record"
  task create: :environment do
    Rails.logger.warn 'Adding a new deployment record.'
    Deployment.create!
  end
end
