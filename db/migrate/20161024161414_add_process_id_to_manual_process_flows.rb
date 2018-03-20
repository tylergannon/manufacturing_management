class AddProcessIdToManualProcessFlows < ActiveRecord::Migration[5.0]
  def change
    add_column :manual_process_flows, :process_id, :string
  end
end
