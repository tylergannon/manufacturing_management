# frozen_string_literal: true
json.extract! shipment, :id, :ships_on, :workflow_state, :created_at, :updated_at
json.url shipment_url(shipment, format: :json)
