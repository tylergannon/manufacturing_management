# frozen_string_literal: true
require_relative '20160417071920_create_purchase_orders'
require_relative '20160417080912_create_line_items'
require_relative '20160417092552_create_line_item_fulfillments'

class RevertPurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    revert CreateLineItemFulfillments
    revert CreateLineItems
    revert CreatePurchaseOrders
  end
end
