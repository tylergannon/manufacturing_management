# frozen_string_literal: true
class AddUpcFilenamesToSkus < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Flavor.flavor1.sku.update upc_filename: "UPC-MasterCase-Flavor1.png"
        Flavor.flavor3.sku.update upc_filename: "UPC-MasterCase-Flavor3.png"
        Flavor.flavor2.sku.update upc_filename: "UPC-MasterCase-Flavor2.png"
      end
    end
  end
end
