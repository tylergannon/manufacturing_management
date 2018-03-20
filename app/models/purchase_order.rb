# frozen_string_literal: true
class PurchaseOrder < ApplicationRecord
  include Workflow
  has_many :shipments, dependent: :nullify
  belongs_to :fulfillment_warehouse, required: false

  S3_CONFIG = {
    storage: :s3,
    url: ':s3_domain_url',
    s3_permissions: :private,
    path: 'uploads/private/purchase_orders/:id/manufacturing-po-:basename.:extension',
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    },
    s3_region: ENV['S3_REGION'],
    bucket: ENV['S3_BUCKET']
  }

  has_attached_file :manufacturing_purchase_order, S3_CONFIG

  validates_attachment :manufacturing_purchase_order,
                       content_type: { content_type: ['application/pdf'] }

  wrap_transition_in_transaction!
  after_transition :save

  workflow do
    state :created do
      on :submit, to: :submitted
      on :initial_payment, to: :initial_payment_made
      on :completed, to: :completed
      on :fulfilled, to: :fulfilled
      on :cancel, to: :cancelled
    end
    state :submitted do
      on :initial_payment, to: :initial_payment_made
      on :completed, to: :completed
      on :fulfilled, to: :fulfilled
      on :cancel, to: :cancelled
    end
    state :initial_payment_made do
      on :begin_production, to: :in_progress
      on :completed, to: :completed
      on :fulfilled, to: :fulfilled
      on :cancel, to: :cancelled
    end
    state :in_progress do
      on :completed, to: :completed
      on :fulfilled, to: :fulfilled
      on :cancel, to: :cancelled
    end
    state :completed do
      on :fulfilled, to: :fulfilled
      on :cancel, to: :cancelled
    end
    state :fulfilled
    state :cancelled
  end
end
