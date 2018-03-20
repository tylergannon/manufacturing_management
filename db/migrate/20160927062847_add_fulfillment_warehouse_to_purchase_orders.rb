class AddFulfillmentWarehouseToPurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :purchase_orders, :fulfillment_warehouse, foreign_key: true
  end
end
