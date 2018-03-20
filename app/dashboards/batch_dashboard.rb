# frozen_string_literal: true
require 'administrate/base_dashboard'

class BatchDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    flavor: Field::BelongsTo,
    shipment: Field::BelongsTo,
    manager_on_duty: Field::BelongsTo.with_options(class_name: 'User'),
    recipe: RecipeField,
    id: Field::Number,
    production_date: Field::DateTime,
    manager_on_duty_id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    slug: Field::String,
    batch_number: Field::String,
    net_weight_sellable: Field::Number.with_options(decimals: 2),
    net_weight_seconds: Field::Number.with_options(decimals: 2),
    fresh_primary_ingredient_loss: Field::Number.with_options(decimals: 2)
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :batch_number,
    :flavor,
    :shipment,
    :production_date,
    :manager_on_duty,
    :recipe
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :flavor,
    :recipe,
    :shipment,
    :manager_on_duty,
    :id,
    :production_date,
    :manager_on_duty_id,
    :created_at,
    :updated_at,
    :slug,
    :net_weight_sellable,
    :net_weight_seconds,
    :fresh_primary_ingredient_loss
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :recipe,
    :shipment,
    :manager_on_duty,
    :production_date,
    :manager_on_duty_id,
    :net_weight_sellable,
    :net_weight_seconds,
    :fresh_primary_ingredient_loss
  ].freeze

  def display_resource(batch)
    batch.batch_number + ' ' + batch.flavor.name
  end
end
