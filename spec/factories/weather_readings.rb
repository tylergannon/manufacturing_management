# frozen_string_literal: true
FactoryGirl.define do
  factory :weather_reading do
    latitude 1.5
    longitude 1.5
    city 'MyString'
    taken_at '2016-04-23 21:21:52'
  end
end
