# frozen_string_literal: true
class RecipeReport < PdfDocument
  def build_pdf
    h1 "Manufacturing Recipe Report #{Date.today}"
    space
    text 'Proprietary and confidential.  Do not distribute.'
    space

    Flavor.all.each do |flavor|
      h2 flavor.name
      space

      pdf.table recipe_table(flavor)
      3.times { space }
    end
  end

  def recipe_table(flavor)
    [recipe_ingredient_heading] +
      flavor.default_recipe.recipe_ingredients.map { |t| recipe_ingredient_row(t) }
  end

  def initialize(pdf)
    self.pdf = pdf
    super
  end

  def recipe_ingredient_heading
    ['Ingredient', 'Grams/Kilo PrimaryIngredient', 'Kg/100kg PrimaryIngredient']
  end

  def recipe_ingredient_row(recipe_ingredient)
    [recipe_ingredient.name,
     recipe_ingredient.grams_per_kilo_primary_ingredient.round(3),
     (recipe_ingredient.grams_per_kilo_primary_ingredient * 10).round(3)]
  end
end
