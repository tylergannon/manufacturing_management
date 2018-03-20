# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    email { "#{SecureRandom.uuid}@nowhere.com" }
    first_name 'Somebody'
    last_name 'Special'
    password { SecureRandom.uuid }
  end
end
