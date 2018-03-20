# frozen_string_literal: true
class SaveGcalEventJob < ApplicationJob
  queue_as :default

  def perform(gcal_event)
    gcal_event.save_to_calendar!
  end
end
