# frozen_string_literal: true
module ManualDocumentWorkflow
  extend ActiveSupport::Concern
  included do
    include Workflow

    belongs_to :author, class_name: 'User', required: true
    validates :title, presence: true
    validates :version, presence: true
    validates :workflow_state, presence: true
    validates :body, presence: true

    workflow do
      state :initial_draft do
        on :complete, to: :review
      end
      state :review do
        on :feedback, to: :revision
        on :accept, to: :ready_for_publication
      end
      state :revision do
        on :accept, to: :ready_for_publication
      end
      state :ready_for_publication
    end
  end
end
