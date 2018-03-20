# frozen_string_literal: true
FactoryGirl.define do
  factory :shipment do
    ships_on { Date.parse('2016-08-20') }
    workflow_state 'scheduled'

    factory :shipment_shipped do
      workflow_state 'shipped'
      boxes_packed_flavor1 20
      boxes_packed_flavor3 10
      boxes_packed_flavor2 10
      house_airway_bill '1234'
      master_airway_bill '1234'
      carrier 'DHL'
      batches { create :batch }
    end
  end
end
