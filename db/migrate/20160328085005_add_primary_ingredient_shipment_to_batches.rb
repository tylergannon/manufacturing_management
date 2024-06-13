# frozen_string_literal: true
class AddPrimaryIngredientShipmentToBatches < ActiveRecord::Migration[5.0]
  def change
    add_reference :batches, :primary_ingredient_shipment, foreign_key: true
  end
end
