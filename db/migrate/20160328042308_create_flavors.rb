# frozen_string_literal: true
class CreateFlavors < ActiveRecord::Migration[5.0]
  def change
    create_table :flavors do |t|
      t.string :name
      t.string :abbreviation

      t.timestamps
    end
  end
end
