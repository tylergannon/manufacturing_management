# frozen_string_literal: true
FactoryGirl.define do
  factory :batch_log do
    batch nil
    action 'MyString'
    approved_by nil
    approved_at '2016-04-17 08:51:48'
  end
end
