# frozen_string_literal: true
FactoryGirl.define do
  factory :batch do
    recipe
    production_date '2016-03-28'
    association :manager_on_duty, factory: :user
    workflow_state 'scheduled'

    factory :batch_with_shipment do
      gross_fresh_primary_ingredient 12.234
      shipment
      recipe { create :recipe_flavor3 }

      factory :batch_started do
        workflow_state 'started'
      end

      factory :batch_qa do
        workflow_state 'qa'
        pouches_produced 123
        net_weight_sellable 123
      end

      factory :batch_with_issue do
        workflow_state 'inquest'
      end

      factory :batch_accepted do
        cartons_packed 123
        pouches_produced 123
        net_weight_sellable 123
        workflow_state 'accepted'
      end
    end
  end
end
