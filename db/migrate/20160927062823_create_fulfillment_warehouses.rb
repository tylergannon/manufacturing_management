class CreateFulfillmentWarehouses < ActiveRecord::Migration[5.0]
  WAREHOUSES = ['UNFI Racine', 'UNFI Iowa', 'UNFI Aurora']
  def change
    create_table :fulfillment_warehouses do |t|
      t.string :name

      t.timestamps
    end
    reversible do |direction|
      direction.up do
        WAREHOUSES.each do |wh|
          FulfillmentWarehouse.create! name: wh
        end
      end
    end
  end
end
