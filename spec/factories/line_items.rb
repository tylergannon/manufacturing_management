# frozen_string_literal: true
FactoryGirl.define do
  factory :line_item do
    sku nil
    quantity 1
    purchase_order nil
  end
end
