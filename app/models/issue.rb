# frozen_string_literal: true
class Issue < ApplicationRecord
  belongs_to :batch, required: true
  include Workflow

  validate :dont_have_two_open_siblings, if: :opened?

  def dont_have_two_open_siblings
    return unless batch.issues.with_opened_state.where.not(id: id).count.positive?
    errors.add :batch, "Can't open a new issue when one already exists."
  end

  after_transition :save

  workflow do
    state :opened do
      on :resolve, to: :resolved
    end

    state :resolved
  end
end
