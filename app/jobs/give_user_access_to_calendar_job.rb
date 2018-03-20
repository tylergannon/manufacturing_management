# frozen_string_literal: true
class GiveUserAccessToCalendarJob < ApplicationJob
  queue_as :default

  def perform(calendar, user)
    calendar.give_user_access(user)
  end
end
