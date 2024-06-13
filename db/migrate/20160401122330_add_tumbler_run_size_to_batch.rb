# frozen_string_literal: true
class AddTumblerRunSizeToBatch < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :tumbler_run_size, :integer
  end
end
