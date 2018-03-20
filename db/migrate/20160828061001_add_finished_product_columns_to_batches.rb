# frozen_string_literal: true
class AddFinishedProductColumnsToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :unusable_thin_product, :float
    add_column :batches, :unusable_thick_product, :float
    add_column :batches, :unusable_other_product, :float
  end
end
