# frozen_string_literal: true
class Recipe < ApplicationRecord
  ACTIVE_RECIPE_ID = 'active'

  MARINADE_TO_MEAT_RATIO = 0.176
  belongs_to :flavor, touch: true
  has_many :batches

  after_update :touch_batches

  def touch_batches
    batches.each(&:touch)
  end

  after_create :put_me_first!

  default_scope -> { order(:sort_key) }
  has_many :recipe_ingredients do
    def sorted
      order(grams_per_kilo_primary_ingredient: :desc)
    end

    def total_pph
      sum(:parts_per_hundred)
    end

    def total_marinade(kg_primary_ingredient)
      total_grams_marinade_per_kilo_primary_ingredient * kg_primary_ingredient
    end

    def total_grams_marinade_per_kilo_primary_ingredient
      sum(:grams_per_kilo_primary_ingredient)
    end
  end

  def as_json(*_args)
    {
      id: id,
      name: long_name
    }
  end

  def self.find_by_friendly_with_default!(id)
    if id == ACTIVE_RECIPE_ID
      first
    else
      friendly.find(id)
    end
  end

  def long_name
    flavor.name + ' ' + name + ' ' + title.to_s
  end

  def name
    slug ||
      (flavor.recipes.select(&:persisted?).length + 1).to_s(36).upcase +

        flavor.abbreviation.upcase
  end

  scope :current, lambda {
    joins(:flavor).includes(:flavor).order(:flavor_id).limit(3)
  }

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  def slug_candidates
    [[:name]]
  end

  private

  def put_me_first!
    flavor.recipes.to_a.rotate(-1).each_with_index do |recipe, i|
      recipe.update_column 'sort_key', i
    end
  end
end
