# frozen_string_literal: true
class AddShippedOnToShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :shipped_on, :date
  end
end
