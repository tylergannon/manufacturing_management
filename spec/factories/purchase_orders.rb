# frozen_string_literal: true
FactoryGirl.define do
  factory :purchase_order do
    po_number 'MyString'
    due_date '2016-09-26'
    boxes_flavor1 1
    boxes_flavor3 1
    boxes_flavor2 1
  end
end
