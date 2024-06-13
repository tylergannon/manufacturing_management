# frozen_string_literal: true
class AddSlugToFlavors < ActiveRecord::Migration[5.0]
  def change
    add_column :flavors, :slug, :string
    add_index :flavors, :slug
  end
end
