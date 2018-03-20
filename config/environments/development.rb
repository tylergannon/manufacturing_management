# frozen_string_literal: true
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true
  config.active_job.queue_adapter = if ENV['SIDEKIQ']
                                      :sidekiq
                                    else
                                      :inline
                                    end

  # Disable Google Calendar API Integration
  # config.x.google_calendar_api.disabled = true
  # GcalEvent.prepend DisableGoogleCalendar

  config.x.mail_recipients = ['tyler@aprilseven.co']

  # http://ugisozols.com/tracing-sql-queries-in-rails/
  module LogQuerySource
    def debug(*args, &block)
      return unless super

      backtrace = Rails.backtrace_cleaner.clean caller

      relevant_caller_line = backtrace.detect do |caller_line|
        !caller_line.include?('/initializers/')
      end
      return unless relevant_caller_line

      logger.debug("  ↳ #{relevant_caller_line.sub("#{Rails.root}/", '')}")
    end
  end

  if Rails.env.development?
    ActiveRecord::LogSubscriber.send :prepend, LogQuerySource
  end

  # Enable/disable caching. By default caching is disabled.
  if ENV['CACHE']
    puts 'CACHING IS TURNED ON'
    config.action_controller.perform_caching = true

    config.action_mailer.perform_caching = false

    config.cache_store = :dalli_store, nil

    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }

  else
    puts 'caching is turned OFF'
    config.action_controller.perform_caching = false

    config.action_mailer.perform_caching = false

    config.cache_store = :null_store

    # config.assets.configure do |env|
    #   env.cache = ActiveSupport::Cache.lookup_store(:file_store, ENV['TMPDIR'])
    # end
  end

  config.assets.configure do |env|
    env.cache = ActiveSupport::Cache.lookup_store(:redis_store, nil)
  end

  if ENV['MAIL']
    puts 'MAILER IS ON.'
    ActionMailer::Base.smtp_settings = {
      user_name: ENV['SENDGRID_USERNAME'],
      password: ENV['SENDGRID_PASSWORD'],
      domain: 'production.manufacturing.com',
      address: 'smtp.sendgrid.net',
      port: 587,
      authentication: :plain,
      enable_starttls_auto: true
    }
  else
    config.action_mailer.delivery_method = :test
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.quiet = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
