# frozen_string_literal: true
class AddNumberOfCoconutsToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :amount_of_primary_ingredient, :integer
  end
end
