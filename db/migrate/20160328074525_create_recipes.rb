# frozen_string_literal: true
class CreateRecipes < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.references :flavor, foreign_key: true
      t.string :slug, index: true

      t.timestamps
    end
  end
end
