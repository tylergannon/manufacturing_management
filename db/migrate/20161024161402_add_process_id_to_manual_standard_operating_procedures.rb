class AddProcessIdToManualStandardOperatingProcedures < ActiveRecord::Migration[5.0]
  def change
    add_column :manual_standard_operating_procedures, :process_id, :string
  end
end
