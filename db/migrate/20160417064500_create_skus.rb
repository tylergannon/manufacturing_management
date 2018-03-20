# frozen_string_literal: true
class CreateSkus < ActiveRecord::Migration[5.0]
  def change
    create_table :skus do |t|
      t.string :title
      t.references :flavor, foreign_key: true
      t.float :net_weight
      t.timestamps
    end

    reversible do |direction|
      direction.up do
        unless Flavor.any?
          Flavor.create! name: 'flavor1', abbreviation: 'O'
          Flavor.create! name: 'Flavor3', abbreviation: 'L'
          Flavor.create! name: 'Flavor2', abbreviation: 'T'
        end

        Sku.create! net_weight: 0.043,
                    flavor: Flavor.friendly.find('flavor1'),
                    title: "flavor1, 1.5oz"
        Sku.create! net_weight: 0.043,
                    flavor: Flavor.friendly.find('flavor3'),
                    title: "Flavor3, 1.5oz"
        Sku.create! net_weight: 0.043,
                    flavor: Flavor.friendly.find('flavor2'),
                    title: "Flavor2, 1.5oz"
      end
    end
  end
end
