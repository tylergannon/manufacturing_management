# frozen_string_literal: true
class CreateGoogleCalendars < ActiveRecord::Migration[5.0]
  def change
    create_table :google_calendars do |t|
      t.string :name
      t.string :calendar_id
      t.string :title
      t.string :time_zone
      t.string :description
      t.string :location

      t.timestamps
    end
  end
end
