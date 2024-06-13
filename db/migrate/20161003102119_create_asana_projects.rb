class CreateAsanaProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :asana_projects do |t|
      t.datetime :last_updated_at
      t.datetime :status_updated_at
      t.string :status_updated_by
      t.string :status_color
      t.string :title
      t.date :due_date
      t.string :project_id, index: true
      t.string :current_status
      t.string :color
      t.string :notes
      t.boolean :archived
      t.boolean :display_in_dashboard, default: true
      t.timestamps
    end
  end
end
