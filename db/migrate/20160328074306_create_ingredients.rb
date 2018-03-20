# frozen_string_literal: true
class CreateIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :instructions

      t.timestamps
    end
  end
end
