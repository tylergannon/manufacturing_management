# frozen_string_literal: true
FactoryGirl.define do
  factory :recipe_ingredient do
    recipe nil
    ingredient nil
    parts_per_hundred 'MyString'
  end
end
