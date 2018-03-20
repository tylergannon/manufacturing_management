class AddWorkflowStateToPurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_orders, :workflow_state, :string
    add_index :purchase_orders, :workflow_state
  end
end
