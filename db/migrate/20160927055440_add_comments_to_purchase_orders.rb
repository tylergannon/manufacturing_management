class AddCommentsToPurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_orders, :comments, :text
  end
end
