# frozen_string_literal: true
class AddSlugToPrimaryIngredientSuppliers < ActiveRecord::Migration[5.0]
  def change
    add_column :primary_ingredient_suppliers, :slug, :string, index: true

    reversible do |direction|
      direction.up do
        PrimaryIngredientSupplier.all.each do |supplier|
          supplier.update slug: supplier.name.parameterize
        end
      end
    end
  end
end
