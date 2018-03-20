# frozen_string_literal: true
require 'googleauth/stores/file_token_store'
require 'google/apis'
require 'google/apis/calendar_v3'
require 'google/apis/calendar_v3/service'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

unless Object.const_defined? 'Google::Auth::DefaultCredentials::ACCOUNT_TYPE_VAR'
  Google::Auth::DefaultCredentials::ACCOUNT_TYPE_VAR = 'GOOGLE_ACCOUNT_TYPE'
end

Rails.application.configure do
  # config.x.google_calendar_api.scopes = ['https://www.googleapis.com/auth/calendar']
  config.x.google_calendar_api.calendar_id = ENV['GOOGLE_CALENDAR_ID']
end
