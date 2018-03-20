# frozen_string_literal: true
class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.references :sku, foreign_key: true
      t.integer :quantity
      t.references :purchase_order, foreign_key: true

      t.timestamps
    end
  end
end
