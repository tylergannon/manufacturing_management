# frozen_string_literal: true
class CreateIssues < ActiveRecord::Migration[5.0]
  def change
    create_table :issues do |t|
      t.references :batch, foreign_key: true
      t.string :problem
      t.string :steps_to_correct
      t.string :workflow_state, index: true
      t.timestamps
    end
  end
end
