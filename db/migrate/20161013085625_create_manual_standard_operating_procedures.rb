class CreateManualStandardOperatingProcedures < ActiveRecord::Migration[5.0]
  def change
    create_table :manual_standard_operating_procedures do |t|
      t.string :title
      t.string :version
      t.string :document_id
      t.integer :author_id
      t.string :workflow_state
      t.text :body

      t.timestamps
    end
    add_foreign_key :manual_standard_operating_procedures, :users, column: :author_id
  end
end
