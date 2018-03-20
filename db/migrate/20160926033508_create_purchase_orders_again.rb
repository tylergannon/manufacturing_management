# frozen_string_literal: true
class CreatePurchaseOrdersAgain < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_orders do |t|
      t.string :po_number
      t.date :due_date
      t.integer :boxes_flavor1
      t.integer :boxes_flavor3
      t.integer :boxes_flavor2

      t.timestamps
    end
  end
end
