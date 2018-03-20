class CreateDashboardTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :dashboard_tasks do |t|
      t.string :assignee
      t.boolean :completed
      t.datetime :completed_at
      t.datetime :task_created_at
      t.datetime :due_at
      t.datetime :due_on
      t.string :task_id
      t.string :name
      t.string :notes
      t.datetime :task_modified_at
      t.references :dashboard_project, foreign_key: true
      t.integer :sort_key

      t.timestamps
    end
    # add_index :dashboard_tasks, [:dashboard_project_id, :sort_key]
  end
end
