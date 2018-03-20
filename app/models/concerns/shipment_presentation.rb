# frozen_string_literal: true
module ShipmentPresentation
  extend ActiveSupport::Concern

  def warning_class
    if shipped?
      'bg-success'
    elsif cancelled?
      ''
    elsif more_than_a_week_out?
      'bg-info'
    elsif less_than_a_week_out?
      'bg-warning'
    else
      'bg-danger'
    end
  end

  private

  def more_than_a_week_out?
    ships_on > 1.week.from_now
  end

  def less_than_a_week_out?
    ships_on <= 1.week.from_now && ships_on >= 1.days.from_now
  end
end
