# frozen_string_literal: true
class RenameBatchFields < ActiveRecord::Migration[5.0]
  def change
    rename_column :batches, :net_weight_fresh_primary_ingredient, :gross_fresh_primary_ingredient
    if Batch.columns.any?{|t| t.name == "net_weight_primary_ingredient_loss"}
      rename_column :batches, :net_weight_primary_ingredient_loss, :fresh_primary_ingredient_loss
    end
  end
end
