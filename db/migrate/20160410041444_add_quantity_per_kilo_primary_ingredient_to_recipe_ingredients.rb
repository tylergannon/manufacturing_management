# frozen_string_literal: true
class AddQuantityPerKiloPrimaryIngredientToRecipeIngredients < ActiveRecord::Migration[5.0]
  def change
    add_column :recipe_ingredients, :grams_per_kilo_primary_ingredient, :float

    reversible do |direction|
      direction.up do
        RecipeIngredient.all.each do |recipe_ingredient|
          pph = recipe_ingredient.parts_per_hundred
          total_grams_per_kilo_primary_ingredient = Recipe::MARINADE_TO_MEAT_RATIO
          recipe_ingredient.update grams_per_kilo_primary_ingredient: 10 * pph*total_grams_per_kilo_primary_ingredient
        end
      end
    end
  end
end
