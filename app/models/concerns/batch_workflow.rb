# frozen_string_literal: true

module BatchWorkflow
  extend ActiveSupport::Concern

  included do
    include Workflow

    wrap_transition_in_transaction!

    before_transition do |model_params:|
      self.attributes = model_params unless model_params.blank?
    end

    after_transition :save

    before_enter only: [:cancelled, :rejected] do
      self.shipment = nil
    end

    after_transition do |_obj, event, requested_by:|
      log_action! event, requested_by if requested_by
    end

    after_transition only: [:issue] do |requested_by:|
      if requested_by
        IssueMailer.issue_notification(self, requested_by).deliver_later
      end
    end

    after_transition only: :resolve do
      issues.current.resolve!
    end

    def can_transition?(event)
      old_state = nil
      return unless super
      old_state = workflow_state
      self.workflow_state = current_state.find_event(event).evaluate(self).name
      return valid?
    ensure
      self.workflow_state = old_state if old_state
    end

    workflow do
      event_args :requested_by

      state :scheduled, color_name: 'info' do
        on :start,   to: :started,   icon: 'play', bs_class: 'primary'
        on :cancel,  to: :cancelled, icon: 'ban',  bs_class: 'warning', tags: :feedback
      end

      state :started, color_name: 'primary', tags: :in_progress do
        on :finish,  to: :qa,       icon: 'sign-in',     bs_class: 'primary', tags: :feedback
        on :issue,   to: :inquest,  icon: 'exclamation', bs_class: 'warning', tags: :feedback
        on :reject,  to: :rejected, icon: 'ban',         bs_class: 'danger',  tags: :feedback
      end

      state :inquest, color_name: 'warning', tags: :in_progress do
        on :resolve, to: :started,  icon: 'wrench', bs_class: 'success'
        on :reject,  to: :rejected, icon: 'ban',    bs_class: 'danger', tags: :feedback
      end

      state :qa, color_name: 'primary', tags: [:in_progress, :packaged] do
        on :accept,  to: :accepted, icon: 'check', bs_class: 'success', tags: :feedback
        on :reject,  to: :rejected, icon: 'ban',   bs_class: 'danger',  tags: :feedback
      end

      state :accepted, color_name: 'success', tags: [:in_progress, :packaged] do
        on :ship,    to: :shipped,  icon: 'truck', bs_class: 'success'
        on :reject,  to: :rejected, icon: 'ban',   bs_class: 'danger', tags: :feedback
      end

      state :shipped, color_name: 'success', tags: :packaged
      state :rejected, color_name: 'danger', tags: :unshippable
      state :cancelled, color_name: 'warning', tags: :unshippable
    end
  end
end
