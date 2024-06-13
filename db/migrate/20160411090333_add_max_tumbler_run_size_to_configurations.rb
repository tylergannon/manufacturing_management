# frozen_string_literal: true
class AddMaxTumblerRunSizeToConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :configurations, :max_tumbler_run_size, :float
    reversible do |direction|
      direction.up do
        Configuration.instance.update max_tumbler_run_size: 30
      end
    end
  end
end
