# frozen_string_literal: true
class AddWeatherReadingToBatches < ActiveRecord::Migration[5.0]
  def change
    add_reference :batches, :weather_reading, foreign_key: true
  end
end
