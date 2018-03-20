# frozen_string_literal: true
module RecipesHelper
  def active_recipe_path(flavor)
    flavor_recipe_path(flavor, Recipe::ACTIVE_RECIPE_ID)
  end

  def ingredient_quantity(recipe_ingredient, quantity = nil)
    num = recipe_ingredient.compute_quantity(quantity || @primary_ingredient_quantity, @multiplier || 1.0)
    if num > 1000
      "#{(num / 1000).round(3)} kg"
    elsif num > 10
      "#{num.to_i} g"
    else
      "#{num.round(2)} g"
    end
  end
end
