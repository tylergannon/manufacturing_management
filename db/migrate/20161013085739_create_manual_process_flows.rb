class CreateManualProcessFlows < ActiveRecord::Migration[5.0]
  def change
    create_table :manual_process_flows do |t|
      t.string :title
      t.string :version
      t.string :document_id
      t.integer :author_id
      t.string :category
      t.string :product
      t.string :workflow_state
      t.text :body

      t.timestamps
    end
    add_foreign_key :manual_process_flows, :users, column: :author_id
  end
end
