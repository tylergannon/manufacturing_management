# frozen_string_literal: true
class CreatePrimaryIngredientSuppliers < ActiveRecord::Migration[5.0]
  def change
    create_table :primary_ingredient_suppliers do |t|
      t.string :name

      t.timestamps
    end
  end
end
