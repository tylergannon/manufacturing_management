class AddSlugToManualStandardOperatingProcedures < ActiveRecord::Migration[5.0]
  def change
    add_column :manual_standard_operating_procedures, :slug, :string
    add_index :manual_standard_operating_procedures, :slug
    reversible do |direction|
      direction.up do
        Manual::StandardOperatingProcedure.all.each do |process_flow|
          process_flow.slug = process_flow.title.parameterize
          process_flow.save
        end
      end
    end
  end
end
