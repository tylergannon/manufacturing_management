# frozen_string_literal: true
class AddCartonsPackedToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :cartons_packed, :integer
  end
end
