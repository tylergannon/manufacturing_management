# frozen_string_literal: true
class CreateBatchLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :batch_logs do |t|
      t.references :batch, foreign_key: true
      t.string :action
      t.references :approved_by, foreign_key: false
      t.datetime :approved_at

      t.timestamps
    end

    add_foreign_key :batch_logs, :users, column: :approved_by_id, primary_key: :id
  end
end
