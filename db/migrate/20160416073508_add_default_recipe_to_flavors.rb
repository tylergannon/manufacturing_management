# frozen_string_literal: true
class AddDefaultRecipeToFlavors < ActiveRecord::Migration[5.0]
  def change
    add_reference :flavors, :default_recipe, foreign_key: false
    add_foreign_key :flavors, :recipes, column: :default_recipe_id, primary_key: :id
  end
end
