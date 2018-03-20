# frozen_string_literal: true
FactoryGirl.define do
  factory :flavor do
    name 'Flavor1'
    abbreviation 'C'

    factory :flavor_2 do
      name 'Flavor2'
      abbreviation 'B'
    end
  end
end
