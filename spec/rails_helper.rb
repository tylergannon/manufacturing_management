# frozen_string_literal: true
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
DEFAULT_JS_DRIVER = :poltergeist
JS_DRIVER = ENV.key?('CAPYBARA_JS_DRIVER') ? ENV['CAPYBARA_JS_DRIVER'].to_sym : DEFAULT_JS_DRIVER

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('Running specs in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

require 'devise'
require 'cancan/matchers'
if JS_DRIVER == :poltergeist
  require 'capybara/poltergeist'
elsif JS_DRIVER == :webkit
  require 'capybara/webkit'
  require_relative 'support/capybara-webkit.config.rb'
end
require_relative 'support/capybara_helpers.rb'
require_relative 'support/feature_spec_helpers.rb'
require_relative 'support/feature_spec_macros.rb'
require 'database_cleaner'
require 'vcr'
# require 'capybara-screenshot/rspec'
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
OmniAuth.config.test_mode = true

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.extend FeatureSpecHelpers, type: :feature
  config.include FeatureSpecMacros, type: :feature
  config.include FactoryGirl::Syntax::Methods
  config.infer_base_class_for_anonymous_controllers = false

  Capybara.javascript_driver = JS_DRIVER

  # Capybara::Screenshot.autosave_on_failure = false
  config.run_all_when_everything_filtered = true

  config.alias_it_should_behave_like_to :it_has_the_behavior_of,
                                        'has the behavior:'

  VCR.configure do |config|
    config.cassette_library_dir = 'support/cassettes'
    config.hook_into :webmock # or :fakeweb
    config.ignore_hosts '127.0.0.1'
    config.default_cassette_options = {
      record: :once,
      match_requests_on: [:method, :host, :path]
    }
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.use_transactional_fixtures = false
  DatabaseCleaner.strategy = :truncation, {
    except: [ActiveRecord::InternalMetadata.table_name]
  }

  config.before(:each, type: :view) do
    DatabaseCleaner.clean_with :truncation,       except: [ActiveRecord::InternalMetadata.table_name]
  end
  config.before(:each, type: :model) do
    DatabaseCleaner.clean_with :truncation,       except: [ActiveRecord::InternalMetadata.table_name]
  end
  config.before(:each, type: :feature) do
    DatabaseCleaner.clean_with :truncation,       except: [ActiveRecord::InternalMetadata.table_name]
    create :flavor, name: 'Flavor2', abbreviation: 'T',
                    slug: 'flavor2'
    create :flavor, name: 'flavor1', abbreviation: 'O', slug: 'flavor1'
    create :flavor, name: 'Flavor3', abbreviation: 'L', slug: 'flavor3'
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'support/cassettes'
  config.hook_into :webmock # or :fakeweb
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec

    # Choose one or more libraries:
    with.library :active_record
    with.library :active_model
    with.library :action_controller
    # Or, choose the following (which implies all of the above):
    with.library :rails
  end
end
