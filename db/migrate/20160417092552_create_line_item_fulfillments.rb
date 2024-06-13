# frozen_string_literal: true
class CreateLineItemFulfillments < ActiveRecord::Migration[5.0]
  def change
    create_table :line_item_fulfillments do |t|
      t.references :line_item, foreign_key: true
      t.references :batch, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
