# frozen_string_literal: true
class CreateGoogleCalendarsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :google_calendars_users, id: false do |t|
      t.references :user, foreign_key: true
      t.references :google_calendar, foreign_key: true
    end
  end
end
