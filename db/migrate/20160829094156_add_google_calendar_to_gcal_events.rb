# frozen_string_literal: true
class AddGoogleCalendarToGcalEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :gcal_events, :google_calendar, foreign_key: true
  end
end
