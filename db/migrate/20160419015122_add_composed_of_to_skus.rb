# frozen_string_literal: true
class AddComposedOfToSkus < ActiveRecord::Migration[5.0]
  def change
    add_column :skus, :composed_quantity, :integer
    add_reference :skus, :composed_of, foreign_key: false, index: true
    add_foreign_key :skus, :skus, column: :composed_of_id, primary_key: :id
  end
end
