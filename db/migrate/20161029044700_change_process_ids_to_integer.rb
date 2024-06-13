class ChangeProcessIdsToInteger < ActiveRecord::Migration[5.0]
  TABLES = %i(manual_standard_operating_procedures manual_process_flows).freeze
  def change
    reversible do |direction|
      direction.up do
        TABLES.each do |table|
          change_column table, :process_id, "integer USING NULLIF(process_id, '')::int"
        end
      end
      direction.down do
        TABLES.each do |table|
          change_column table, :process_id, :string
        end
      end
    end
  end
end
