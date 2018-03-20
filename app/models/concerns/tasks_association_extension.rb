# frozen_string_literal: true
module TasksAssociationExtension
  def due_this_week
    where(completed: false, due_on: (Date.today..1.week.from_now))
  end

  def completed_last_week
    where(completed: true, completed_at: (1.week.ago..1.day.from_now))
  end

  def created_last_week
    where(task_created_at: (1.week.ago..1.day.from_now))
  end

  def open
    where(completed: false)
  end

  def reload!
    asana_tasks.each_with_index do |task, i|
      dashboard_task = find_or_initialize_by task_id: task.id.to_s
      set_task_attributes_from_asana(dashboard_task, task, i)
      dashboard_task.save
    end
    tasks_to_delete.each(&:destroy)
  end

  private

  TASK_FIELDS = %w(memberships
                   assignee
                   completed
                   completed_at
                   created_at
                   due_at
                   due_on
                   name
                   notes
                   modified_at).freeze

  def set_task_attributes_from_asana(dashboard_task, task, i)
    assignee = Dashboard::Project.find_user_name_by_id(task.assignee['id']) if task.assignee
    dashboard_task.attributes = {
      task_created_at: task.created_at,
      task_modified_at: task.modified_at,
      name: task.name,
      notes: task.notes,
      completed: task.completed,
      completed_at: task.completed_at,
      due_on: task.due_on,
      due_at: task.due_at,
      assignee: assignee,
      sort_key: i
    }
  end

  def tasks_to_delete
    where.not(task_id: asana_tasks.map(&:id).map(&:to_s))
  end

  def asana_tasks
    @asana_tasks ||= asana_project.tasks(options: { fields: TASK_FIELDS })
  end

  def asana_project
    proxy_association.owner.asana_project
  end
end
