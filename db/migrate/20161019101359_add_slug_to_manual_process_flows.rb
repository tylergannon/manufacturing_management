class AddSlugToManualProcessFlows < ActiveRecord::Migration[5.0]
  def change
    add_column :manual_process_flows, :slug, :string
    add_index :manual_process_flows, :slug
    reversible do |direction|
      direction.up do
        Manual::ProcessFlow.all.each do |process_flow|
          process_flow.slug = process_flow.title.parameterize
          process_flow.save
        end
      end
    end
  end
end
