# frozen_string_literal: true
class SetPouchAmountsToZero < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      columns =         [:net_weight_sellable, :net_weight_seconds, :fresh_primary_ingredient_loss, :pouches_produced]

      dir.up do
        columns.each do |column|
          Batch.where(column => nil).update_all column => 0
        end
      end
      dir.down do
        columns.each do |column|
          Batch.where(column => 0).update_all column => nil
        end
      end
    end
  end
end
