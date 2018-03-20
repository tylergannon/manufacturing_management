class AddPurchaseOrderToShipments < ActiveRecord::Migration[5.0]
  def change
    add_reference :shipments, :purchase_order, foreign_key: true
  end
end
