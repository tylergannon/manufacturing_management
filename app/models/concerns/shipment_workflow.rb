# frozen_string_literal: true
module ShipmentWorkflow
  extend ActiveSupport::Concern

  def ship_all_batches
    self.shipped_on = Date.today
    batches.each do |batch|
      puts "Shipping batch #{batch.batch_number}"
      batch.ship!
      puts batch.errors.inspect unless batch.errors.empty?
    end
  end

  included do
    include Workflow

    wrap_transition_in_transaction!

    after_transition :save
    before_enter :ship_all_batches, only: :shipped

    workflow do
      state :scheduled do
        on :prepare_for_shipping, to: :preparing_for_shipping
        on :cancel, to: :cancelled
      end

      state :preparing_for_shipping do
        on :ship, to: :shipped
        on :cancel, to: :cancelled
      end

      state :shipped
      state :cancelled
    end
  end
end
