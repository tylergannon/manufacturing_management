# frozen_string_literal: true
require 'administrate/field/base'

class RecipeField < Administrate::Field::BelongsTo
  def candidate_resources
    data.flavor.recipes.order(:sort_key).limit(5)
  end
end
