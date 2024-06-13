# frozen_string_literal: true
class AddNotesToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :notes, :text
  end
end
