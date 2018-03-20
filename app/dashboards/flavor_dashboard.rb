# frozen_string_literal: true
require 'administrate/base_dashboard'

class FlavorDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    recipes: Field::HasMany,
    id: Field::Number,
    default_recipe: Field::BelongsTo.with_options(class_name: 'Recipe'),
    name: Field::String,
    abbreviation: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    slug: Field::String
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :default_recipe,
    :id,
    :name,
    :abbreviation
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :recipes,
    :name,
    :default_recipe,
    :abbreviation
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :recipes,
    :name,
    :default_recipe,
    :abbreviation,
    :slug
  ].freeze

  # Overwrite this method to customize how flavors are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(flavor)
    flavor.name
  end
end
