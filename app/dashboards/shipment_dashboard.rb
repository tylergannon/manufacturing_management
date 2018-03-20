# frozen_string_literal: true
require 'administrate/base_dashboard'

class ShipmentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    photos: Field::HasMany,
    batches: Field::HasMany,
    id: Field::Number,
    ships_on: Field::DateTime,
    workflow_state: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    ship_by_air: Field::Boolean,
    house_airway_bill: Field::String,
    master_airway_bill: Field::String,
    carrier: Field::String,
    shipped_at: Field::DateTime,
    notes: Field::Text,
    commercial_invoice_file_name: Field::String,
    commercial_invoice_content_type: Field::String,
    commercial_invoice_file_size: Field::Number,
    commercial_invoice_updated_at: Field::DateTime,
    packing_list_file_name: Field::String,
    packing_list_content_type: Field::String,
    packing_list_file_size: Field::Number,
    packing_list_updated_at: Field::DateTime,
    boxes_packed_flavor1: Field::Number,
    boxes_packed_flavor3: Field::Number,
    boxes_packed_flavor2: Field::Number,
    shipped_on: Field::DateTime,
    purchase_order: Field::BelongsTo
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :ships_on,
    :boxes_packed_flavor1,
    :boxes_packed_flavor3,
    :boxes_packed_flavor2,
    :batches,
    :purchase_order
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :purchase_order,
    :boxes_packed_flavor1,
    :boxes_packed_flavor3,
    :boxes_packed_flavor2,
    :batches,
    :ships_on,
    :shipped_at,
    :shipped_on,
    :workflow_state,
    :ship_by_air,
    :house_airway_bill,
    :master_airway_bill,
    :carrier,
    :notes
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :purchase_order,
    :batches,
    :ships_on,
    :shipped_at,
    :shipped_on,
    :ship_by_air,
    :boxes_packed_flavor1,
    :boxes_packed_flavor3,
    :boxes_packed_flavor2,
    :house_airway_bill,
    :master_airway_bill,
    :carrier,
    :notes,
    :workflow_state
  ].freeze

  # Overwrite this method to customize how shipments are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(shipment)
    "Ships: #{shipment.name}"
  end
end
