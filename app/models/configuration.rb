# frozen_string_literal: true
class Configuration < ApplicationRecord
  belongs_to :default_tumbler_program, class_name: 'TumblerProgram'

  def self.instance
    first
  end
end
