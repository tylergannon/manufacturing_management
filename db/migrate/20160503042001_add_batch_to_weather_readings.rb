# frozen_string_literal: true
class AddBatchToWeatherReadings < ActiveRecord::Migration[5.0]
  def change
    add_reference :weather_readings, :batch, foreign_key: true
    remove_foreign_key :batches, :weather_readings
    remove_reference :batches, :weather_reading
  end
end
