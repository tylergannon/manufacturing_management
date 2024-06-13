# frozen_string_literal: true
class AddRecipeToBatch < ActiveRecord::Migration[5.0]
  def change
    add_reference :batches, :recipe, foreign_key: true
  end
end
