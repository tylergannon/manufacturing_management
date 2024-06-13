# frozen_string_literal: true
class AddHarvestQuantitiesToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :harvest_thick, :float
    add_column :batches, :harvest_thin, :float
    add_column :batches, :harvest_good, :float
    add_column :batches, :harvest_scraps, :float
  end
end
