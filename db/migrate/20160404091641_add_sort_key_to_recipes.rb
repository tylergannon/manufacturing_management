# frozen_string_literal: true
class AddSortKeyToRecipes < ActiveRecord::Migration[5.0]
  def change
    add_column :recipes, :sort_key, :integer
    add_index :recipes, [:flavor_id, :sort_key]
  end
end
