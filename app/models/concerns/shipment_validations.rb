# frozen_string_literal: true
module ShipmentValidations
  extend ActiveSupport::Concern

  included do
    validates :ships_on, presence: true

    validates :boxes_packed_flavor1,
              numericality: { greater_than_or_equal_to: 0 },
              if: :shipped?

    validates :boxes_packed_flavor3,
              numericality: { greater_than_or_equal_to: 0 },
              if: :shipped?

    validates :boxes_packed_flavor2,
              numericality: { greater_than_or_equal_to: 0 },
              if: :shipped?

    validates :house_airway_bill, presence: true, if: :shipped?
    validates :master_airway_bill, presence: true, if: :shipped?
    validates :carrier, presence: true, if: :shipped?

    validate :must_have_commercial_invoice, if: :shipped?
    validate :must_have_packing_list, if: :shipped?

    validate :must_ship_something, if: :shipped?
  end

  def must_ship_something
    return if total_boxes.positive?
    errors.add :boxes_packed_flavor1, 'Must be some of at least one flavor.'
    errors.add :boxes_packed_flavor3, 'Must be some of at least one flavor.'
    errors.add :boxes_packed_flavor2, 'Must be some of at least one flavor.'
  end

  def must_have_commercial_invoice
    errors.add :commercial_invoice, 'Must have a commercial invoice' unless commercial_invoice?
  end

  def must_have_packing_list
    errors.add :packing_list, 'Must have a commercial invoice' unless packing_list?
  end
end
