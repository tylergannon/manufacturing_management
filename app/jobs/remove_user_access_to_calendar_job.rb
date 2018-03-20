# frozen_string_literal: true
class RemoveUserAccessToCalendarJob < ApplicationJob
  queue_as :default

  def perform(calendar, user)
    calendar.remove_user_access(user)
  end
end
