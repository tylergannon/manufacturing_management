class CreatePurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_orders do |t|
      t.references :placed_by, foreign_key: false
      t.references :entered_by, foreign_key: false
      t.date :due_date
      t.string :workflow_state

      t.timestamps
    end
    add_foreign_key :purchase_orders, :users, column: :placed_by_id, primary_key: :id
    add_foreign_key :purchase_orders, :users, column: :entered_by_id, primary_key: :id
  end
end
