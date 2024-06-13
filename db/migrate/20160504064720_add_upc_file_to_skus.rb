# frozen_string_literal: true
class AddUpcFileToSkus < ActiveRecord::Migration[5.0]
  def change
    add_column :skus, :upc_filename, :string
  end
end
