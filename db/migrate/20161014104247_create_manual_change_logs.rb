class CreateManualChangeLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :manual_change_logs do |t|
      t.string :document_type
      t.integer :document_id
      t.string :body
      t.string :notes
      t.string :version
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
