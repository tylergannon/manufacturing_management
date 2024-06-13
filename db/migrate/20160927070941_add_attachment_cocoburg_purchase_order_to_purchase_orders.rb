class AddAttachmentManufacturingPurchaseOrderToPurchaseOrders < ActiveRecord::Migration
  def self.up
    change_table :purchase_orders do |t|
      t.attachment :manufacturing_purchase_order
    end
  end

  def self.down
    remove_attachment :purchase_orders, :manufacturing_purchase_order
  end
end
