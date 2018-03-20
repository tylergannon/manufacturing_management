# frozen_string_literal: true
FactoryGirl.define do
  factory :recipe do
    flavor
    title { SecureRandom.uuid }

    factory :recipe_flavor3 do
      flavor { create :flavor_2 }
    end
  end
end
