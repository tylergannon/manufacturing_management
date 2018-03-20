# frozen_string_literal: true
require 'administrate/base_dashboard'

class PurchaseOrderDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    po_number: Field::String,
    workflow_state: Field::String,
    fulfillment_warehouse: Field::BelongsTo,
    due_date: Field::DateTime,
    boxes_flavor1: Field::Number,
    boxes_flavor3: Field::Number,
    boxes_flavor2: Field::Number,
    manufacturing_purchase_order: PaperclipAttachmentField,
    shipments: Field::HasMany,
    comments: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :po_number,
    :due_date,
    :boxes_flavor1,
    :boxes_flavor3,
    :boxes_flavor2,
    :fulfillment_warehouse,
    :workflow_state
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :po_number,
    :shipments,
    :due_date,
    :fulfillment_warehouse,
    :boxes_flavor1,
    :boxes_flavor3,
    :boxes_flavor2,
    :manufacturing_purchase_order,
    :comments,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :po_number,
    :due_date,
    :fulfillment_warehouse,
    :shipments,
    :boxes_flavor1,
    :boxes_flavor3,
    :boxes_flavor2,
    :manufacturing_purchase_order,
    :comments
  ].freeze

  def display_resource(purchase_order)
    purchase_order.po_number
  end
end
