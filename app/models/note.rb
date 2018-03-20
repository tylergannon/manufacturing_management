# frozen_string_literal: true
class Note < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :noteworthy, polymorphic: true, required: true, touch: true

  default_scope -> { order(updated_at: :desc) }
end
