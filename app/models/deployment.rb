# frozen_string_literal: true
class Deployment < ApplicationRecord
  default_value_for :deployed_at do
    DateTime.now
  end

  def self.latest_deployment
    maximum(:deployed_at)
  end
end
