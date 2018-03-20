# frozen_string_literal: true
module Dashboard
  class Task < ApplicationRecord
    include AsanaApi

    belongs_to :project, required: true, foreign_key: 'dashboard_project_id'

    default_scope -> { order(:dashboard_project_id, :sort_key) }

    def complete!
      self.completed = true
      self.completed_at = DateTime.now
      save_asana complete: true
      save
    end

    def save_asana(**args)
      api_client.put("/tasks/#{task_id}", body: args, options: {})
    end

    def asana_task
      @asana_task ||= Asana::Task.find_by_id(api_client, task_id.to_i)
    end

    def task_url
      "https://app.asana.com/0/#{project.project_id}/#{task_id}"
    end
  end
end
