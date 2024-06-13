require_relative '20161003102119_create_asana_projects.rb'

class CreateDashboardProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :dashboard_projects do |t|
      t.string :name
      t.datetime :project_modified_at
      t.datetime :status_updated_at
      t.string :status_updated_by
      t.string :status_color
      t.string :name
      t.date :due_date
      t.string :project_id
      t.string :current_status
      t.string :color
      t.string :notes
      t.boolean :archived
      t.boolean :display_in_dashboard, default: true

      t.timestamps
    end
    revert CreateAsanaProjects
  end
end
