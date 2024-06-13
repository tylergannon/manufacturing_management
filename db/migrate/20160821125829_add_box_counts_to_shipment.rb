# frozen_string_literal: true
class AddBoxCountsToShipment < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :boxes_packed_flavor1, :integer
    add_column :shipments, :boxes_packed_flavor3, :integer
    add_column :shipments, :boxes_packed_flavor2, :integer
  end
end
