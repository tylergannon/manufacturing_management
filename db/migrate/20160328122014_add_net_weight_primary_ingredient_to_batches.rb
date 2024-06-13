# frozen_string_literal: true
class AddNetWeighFreshPrimaryIngredientToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :net_weight_fresh_primary_ingredient, :float
  end
end
