# frozen_string_literal: true
class CreateConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :configurations do |t|
      t.references :default_tumbler_program, foreign_key: false

      t.timestamps
    end
    reversible do |direction|
      direction.up do
        Configuration.create
      end
    end
  end
end
