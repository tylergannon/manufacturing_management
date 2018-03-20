# frozen_string_literal: true
class AddShipByAirToShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :ship_by_air, :boolean
  end
end
