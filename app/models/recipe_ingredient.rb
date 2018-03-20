# frozen_string_literal: true
class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  delegate :name, to: :ingredient

  attr_accessor :quantity

  def compute_quantity(primary_ingredient_quantity, multiplier = 1)
    grams_per_kilo_primary_ingredient * primary_ingredient_quantity * multiplier
  end

  def pph
    return 0 if recipe.recipe_ingredients.sum(&:grams_per_kilo_primary_ingredient).zero?

    ((grams_per_kilo_primary_ingredient || 0) * 100 /
    recipe.recipe_ingredients.sum(&:grams_per_kilo_primary_ingredient)).round(2)
  end

  def minus_pph
    -pph
  end
end
