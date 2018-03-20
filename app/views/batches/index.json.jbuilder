# frozen_string_literal: true
json.array!(@batches) do |batch|
  json.extract! batch, :id, :flavor_id, :production_date, :manager_on_duty_id
  json.url batch_url(batch, format: :json)
end
