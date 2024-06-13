class AddQuantitiesOrderedToShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :boxes_ordered_flavor1, :integer
    add_column :shipments, :boxes_ordered_flavor3, :integer
    add_column :shipments, :boxes_ordered_flavor2, :integer
  end
end
