# frozen_string_literal: true
class AddTitleToRecipes < ActiveRecord::Migration[5.0]
  def change
    add_column :recipes, :title, :string
    add_column :recipes, :description, :string
  end
end
