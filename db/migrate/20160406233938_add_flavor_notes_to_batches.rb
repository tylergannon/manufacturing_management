# frozen_string_literal: true
class AddFlavorNotesToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :flavor_notes, :string
  end
end
