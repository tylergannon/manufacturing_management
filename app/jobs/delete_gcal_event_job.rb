# frozen_string_literal: true
class DeleteGcalEventJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    GcalEvent.new.delete_calendar_event!(event_id)
  end
end
