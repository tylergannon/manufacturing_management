# frozen_string_literal: true
FactoryGirl.define do
  factory :primary_ingredient_shipment do
    received_at '2016-03-28 13:41:17'
    primary_ingredient_supplier nil
    amount_in_kg 1.5
    notes 'MyString'
  end
end
