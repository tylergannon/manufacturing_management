# frozen_string_literal: true
class AddPouchesProducedToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :pouches_produced, :integer
  end
end
