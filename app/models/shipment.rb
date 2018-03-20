# frozen_string_literal: true

class Shipment < ApplicationRecord
  include ShipmentValidations
  include ShipmentPresentation
  include ShipmentWorkflow

  has_many :photos, as: :owner
  has_many :batches, dependent: :nullify
  belongs_to :purchase_order, touch: true, required: false
  default_value_for :ship_by_air, false

  def total_boxes
    boxes_packed_flavor1.to_i + boxes_packed_flavor3.to_i + boxes_packed_flavor2.to_i
  end

  SHIPPING_TIME_AIR = 5.days
  SHIPPING_TIME_OCEAN = 7.weeks
  OFFICIAL_SHELF_LIFE = 1.year + SHIPPING_TIME_OCEAN

  # validate :only_ship_accepted_batches, if: :preparing_for_shipping?

  [:commercial_invoice, :packing_list].each do |attribute|
    has_attached_file attribute, {
      storage: :s3,
      url: ':s3_domain_url',
      s3_permissions: :private,
      path: "uploads/shipments/:id/#{attribute}/:basename.:extension",
      s3_credentials: {
        access_key_id: ENV['S3_KEY'],
        secret_access_key: ENV['S3_SECRET']
      },
      s3_region: ENV['S3_REGION'],
      bucket: ENV['S3_BUCKET']
    }

    validates_attachment attribute,
                         content_type: { content_type: ['application/pdf'] }
  end

  process_in_background :commercial_invoice
  process_in_background :packing_list

  def ready_to_go?
    return false unless photos.any? && batches.all?(&:accepted?)
  end

  def name
    ships_on.strftime('%b %-d')
  end

  def to_param(*_args)
    id.to_s(16)
  end

  def self.find_by_hex!(hex)
    find(hex.to_i(16))
  end

  def self.find_by_hex_with_show_data!(hex)
    includes(:photos, { batches: [{ recipe: :flavor }] })
      .find_by_hex!(hex)
  end

  def expiration_date
    ships_on + OFFICIAL_SHELF_LIFE
    # if ship_by_air
    #   ships_on + OFFICIAL_SHELF_LIFE + SHIPPING_TIME_AIR
    # else
    #   ships_on + OFFICIAL_SHELF_LIFE + SHIPPING_TIME_OCEAN
    # end
  end

  def only_ship_accepted_batches
    batches.where.not(workflow_state: 'accepted').each do |batch|
      errors[:batches] << batch
    end
  end

  default_scope -> { order(ships_on: :desc) }

  scope :index, lambda {
    unscoped.where(workflow_state: %w(scheduled preparing_for_shipping))
            .order(ships_on: :asc)
  }

  scope :recent, lambda {
    Shipment.with_shipped_state
  }

  def all_batches_ready?
    batches.all? { |t| t.accepted? || t.shipped? }
  end

  after_enter only: :cancelled do
    batches.clear
  end
end
