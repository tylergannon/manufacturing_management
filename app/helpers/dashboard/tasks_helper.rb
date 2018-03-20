# frozen_string_literal: true
module Dashboard
  module TasksHelper
    def task_due_class(task)
      if task.due_on.nil?
        'tag-default'
      elsif task.due_on >= 3.days.from_now
        'tag-default'
      elsif task.due_on >= Date.today
        'tag-warning'
      else
        'tag-danger'
      end
    end

    def task_friendly_date(d)
      return nil unless d
      if d <= 1.week.from_now && d >= Date.today
        d.strftime('%a')
      elsif d.year != Date.today.year
        d.strftime('%b %-d, %Y')
      else
        d.strftime('%b %-d')
      end
    end
  end
end
