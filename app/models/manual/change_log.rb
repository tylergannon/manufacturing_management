# frozen_string_literal: true
module Manual
  class ChangeLog < ApplicationRecord
    belongs_to :user, required: false
    belongs_to :document, polymorphic: true, required: true

    before_create :set_body_and_version

    private

    def set_body_and_version
      self.body = document.body
      self.version = document.version
    end
  end
end
