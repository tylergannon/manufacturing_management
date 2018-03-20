# frozen_string_literal: true
FactoryGirl.define do
  factory :line_item_fulfillment do
    line_item nil
    batch nil
    quantity 1
  end
end
