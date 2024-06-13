# frozen_string_literal: true
class AddShipmentToBatches < ActiveRecord::Migration[5.0]
  def change
    add_reference :batches, :shipment, foreign_key: true
  end
end
