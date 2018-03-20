# frozen_string_literal: true
FactoryGirl.define do
  factory :note do
    user nil
    notes 'MyText'
    noteworthy_id 1
    noteworthy_type 'MyString'
  end
end
