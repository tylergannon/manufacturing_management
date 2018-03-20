# frozen_string_literal: true
module BatchValidations
  extend ActiveSupport::Concern

  included do
    validates :recipe, presence: true
    validates :production_date, presence: true
    validates :gross_fresh_primary_ingredient, numericality: { greater_than: 0 },
                                 unless: :scheduled?

    validates :pouches_produced, numericality: { greater_than: 0 },
                                 if: -> { current_state >= :qa },
                                 unless: -> { current_state.tags.include?(:unshippable) }
    validates :net_weight_sellable, numericality: { greater_than: 0 },
                                    if: -> { current_state >= :qa },
                                    unless: -> { current_state.tags.include?(:unshippable) }

    validates :cartons_packed, numericality: { greater_than: 0 },
                               if: -> { current_state >= :accepted },
                               unless: -> { current_state.tags.include?(:unshippable) }

    validates :shipment, presence: true,
                         if: -> { current_state > :scheduled },
                         unless: -> { current_state.tags.include?(:unshippable) }

    # validate :cancellation_reason, if: :transitioning_to_cancelled?
    # validate :rejection_reason, if: :transitioning_to_rejected?

    validate :issues_should_be_valid

    validate :shipment_should_be_shipped, if: :shipped?
  end

  def shipment_should_be_shipped
    return if shipment.shipped?
    errors.add :shipment, 'Shipment must be shipped in order to ship a batch.'
  end

  def issues_should_be_valid
    return if issues.all?(&:valid?)
    errors.add :issues, 'Problem with issue validity.'
  end
end
