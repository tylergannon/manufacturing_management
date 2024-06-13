# frozen_string_literal: true
class AddIndexToBatchesProductionDate < ActiveRecord::Migration[5.0]
  def change
    add_index :batches, :production_date
  end
end
