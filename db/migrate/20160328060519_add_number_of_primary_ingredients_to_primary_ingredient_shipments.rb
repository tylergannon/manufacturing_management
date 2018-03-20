# frozen_string_literal: true
class AddNumberOfCoconutsToPrimaryIngredientShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :primary_ingredient_shipments, :amount_of_primary_ingredient, :integer
  end
end
