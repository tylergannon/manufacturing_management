# frozen_string_literal: true
class CreatePrimaryIngredientShipments < ActiveRecord::Migration[5.0]
  def change
    create_table :primary_ingredient_shipments do |t|
      t.datetime :received_at
      t.references :primary_ingredient_supplier, foreign_key: true
      t.float :amount_in_kg
      t.string :notes, limit: 5000

      t.timestamps
    end
  end
end
