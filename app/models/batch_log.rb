# frozen_string_literal: true
class BatchLog < ApplicationRecord
  belongs_to :batch
  belongs_to :approved_by, class_name: 'User'

  default_scope -> { order(approved_at: :desc) }

  [:batch, :approved_by, :action, :approved_at].each do |attr|
    validates attr, presence: true
  end

  INFLECTIONS = {
    start: 'started',
    cancel: 'cancelled',
    finish: 'finished',
    issue: 'reported issue',
    reject: 'rejected',
    resolve: 'resolved',
    accept: 'accepted',
    ship: 'shipped'
  }.freeze

  def inflect_past_tense
    INFLECTIONS[action.to_sym]
  end
end
