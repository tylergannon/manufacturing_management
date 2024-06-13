# frozen_string_literal: true
class AddUnitwiseTemperatureHumidityPressureToWeatherReadings < ActiveRecord::Migration
  def change
    add_column :weather_readings, :temperature_scalar, :float
    add_column :weather_readings, :temperature_units, :string, limit: 50
    add_column :weather_readings, :humidity_scalar, :float
    add_column :weather_readings, :humidity_units, :string, limit: 50
    add_column :weather_readings, :pressure_scalar, :float
    add_column :weather_readings, :pressure_units, :string, limit: 50
  end
end
