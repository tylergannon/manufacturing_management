# frozen_string_literal: true
class CreateWeatherReadings < ActiveRecord::Migration[5.0]
  def change
    create_table :weather_readings do |t|
      t.float :latitude
      t.float :longitude
      t.string :city
      t.datetime :taken_at

      t.timestamps
    end
  end
end
