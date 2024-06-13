# frozen_string_literal: true
class CreateRecipeIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.float :parts_per_hundred

      t.timestamps
    end
  end
end
