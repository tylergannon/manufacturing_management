# frozen_string_literal: true
class CreateTumblerPrograms < ActiveRecord::Migration[5.0]
  def change
    create_table :tumbler_programs do |t|
      t.integer :running_time
      t.integer :idle_time

      t.timestamps
    end
  end
end
