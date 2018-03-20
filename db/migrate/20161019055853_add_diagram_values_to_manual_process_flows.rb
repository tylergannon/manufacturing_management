class AddDiagramValuesToManualProcessFlows < ActiveRecord::Migration[5.0]
  def change
    add_column :manual_process_flows, :layout, :string
    add_column :manual_process_flows, :aspect_ratio, :float
  end
end
