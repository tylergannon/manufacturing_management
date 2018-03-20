# frozen_string_literal: true
source 'https://rubygems.org'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

gem 'rails', '>= 5.0.0', '< 5.1'
gem 'asana'
gem 'aws-sdk'
gem 'axlsx_rails'
gem 'bootstrap', '~> 4.0.0.alpha5'
gem 'cancancan'
gem 'chosen-rails'
gem 'coffee-rails', '~> 4.1.0'
gem 'dalli'
gem 'default_value_for', '>= 3.0.2'
gem 'delayed_paperclip'
gem 'devise', '>= 4.2'
gem 'rubyzip'
gem 'font-awesome-sass'
gem 'friendly_id', github: 'norman/friendly_id'
gem 'google-api-client'
gem 'handlebars_assets'
gem 'ace-rails-ap'
gem 'jquery-fileupload-rails'
gem 'jquery-rails'
gem 'kaminari' # , github: "amatsuda/kaminari"
gem 'omniauth-google-oauth2'
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'paperclip'
gem 'pg'
gem 'prawn-table'
gem 'prawn'
gem 'premailer-rails'
gem 'puma'
gem 'redis-rails'
gem 'responders'
gem 'sassc-rails'
gem 'rails-sanitize-js'
gem 'sidekiq'
gem 'simple_form'
gem 'slim-rails'
gem 'kramdown' # For markdown in slim templates
gem 'turbolinks', '>= 5.0.0'
gem 'twitter-bootstrap-rails-confirm'
gem 'uglifier', '>= 1.3.0'
# gem 'rails-workflow', path: '/Users/tyler/src/workflow'
gem 'rails-workflow', '~> 1.4'
gem 'administrate', github: 'thoughtbot/administrate'

source 'https://rails-assets.org' do
  # For bootstrap errors.  When time look into disabling popovers and
  gem 'rails-assets-tether', '>= 1.1.0'
  gem 'rails-assets-highlightjs'
  gem 'rails-assets-bourbon'
  gem 'rails-assets-keymaster'
  gem 'rails-assets-parsleyjs'
  gem 'rails-assets-swiper'
  gem 'rails-assets-nathancahill--Split.js'
end

group :development, :test do
  gem 'rb-readline'
  # gem 'byebug'
  gem 'pry', '0.11.0.pre'
  gem 'pry-byebug'
  gem 'dotenv-rails'
  gem 'listen'
  gem 'spring-commands-rspec'
  gem 'spring-commands-rubocop'
  gem 'rubocop', require: nil
  gem 'spring'
  gem 'rspec-rails', '>= 3.5.1'
  # gem 'foreman'
end

group :production do
  gem 'rails_12factor'
end

# group :development do
#   gem 'web-console', '~> 3.0'
# end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'smart_rspec', github: 'tylergannon/smart_rspec'
  gem 'guard-rspec', require: false
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  # gem 'capybara-webkit'
  gem 'vcr'
  gem 'webmock'
  # gem 'capybara-screenshot'
end

ruby '2.3.1'
