# frozen_string_literal: true
class AddSlugToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :slug, :string
    add_index :batches, :slug
  end
end
