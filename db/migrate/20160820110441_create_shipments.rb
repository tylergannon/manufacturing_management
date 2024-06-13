# frozen_string_literal: true
class CreateShipments < ActiveRecord::Migration[5.0]
  def change
    create_table :shipments do |t|
      t.date :ships_on
      t.string :workflow_state

      t.timestamps
    end
  end
end
