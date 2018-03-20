# frozen_string_literal: true
module IngredientsGetter
  QUERY = "
    SELECT ingredients.*,
          sum(recipe_ingredients.grams_per_kilo_primary_ingredient * batches.gross_fresh_primary_ingredient) as quantity
    FROM ingredients
      INNER JOIN recipe_ingredients
        ON ingredients.id = recipe_ingredients.ingredient_id
      INNER JOIN recipes
        ON recipe_ingredients.recipe_id = recipes.id
      INNER JOIN batches
        ON batches.recipe_id = recipes.id
    WHERE batches.id in (?)
    GROUP BY ingredients.id
    ORDER BY quantity DESC
  "

  def all_ingredients
    Ingredient.find_by_sql [QUERY, pluck(:id)]
  end
end
