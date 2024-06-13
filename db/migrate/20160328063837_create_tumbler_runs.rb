# frozen_string_literal: true
class CreateTumblerRuns < ActiveRecord::Migration[5.0]
  def change
    create_table :tumbler_runs do |t|
      t.references :batch, foreign_key: true
      t.references :tumbler_program, foreign_key: true
      t.datetime :started_at
      t.datetime :finished_at
      t.float :primary_ingredient_quantity
      t.float :marinade_quantity

      t.timestamps
    end
  end
end
