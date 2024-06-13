# frozen_string_literal: true
class AddFieldsToShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :house_airway_bill, :string
    add_column :shipments, :master_airway_bill, :string
    add_column :shipments, :carrier, :string
    add_column :shipments, :shipped_at, :datetime
    add_column :shipments, :notes, :text
  end
end
