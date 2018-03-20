# frozen_string_literal: true
class AddNetSellableWeightToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :net_weight_sellable, :float
    add_column :batches, :net_weight_seconds, :float
    add_column :batches, :fresh_primary_ingredient_loss, :float
  end
end
