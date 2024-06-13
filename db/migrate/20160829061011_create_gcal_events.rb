# frozen_string_literal: true
class CreateGcalEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :gcal_events do |t|
      t.references :batch, foreign_key: true
      t.string :event_id

      t.timestamps
    end
  end
end
