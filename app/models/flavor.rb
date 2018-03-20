# frozen_string_literal: true
class Flavor < ApplicationRecord
  has_many :recipes
  has_many :batches, through: :recipes
  has_one :sku

  default_scope -> { order(:id) }

  NAMES = {
    'Flavor1' => 'F1',
    'Flavor3' => 'F2',
    'Flavor2' => 'F3'
  }.freeze

  class << self
    def flavor3
      Rails.cache.fetch('flavor3-flavor', expires_in: 1.minutes) do
        friendly.find('flavor3')
      end
    end

    def flavor2
      Rails.cache.fetch('flavor2-flavor', expires_in: 1.minutes) do
        friendly.find('flavor2')
      end
    end

    def flavor1
      Rails.cache.fetch('flavor1-flavor', expires_in: 1.minutes) do
        friendly.find('flavor1')
      end
    end
  end

  def short_name
    NAMES[name]
  end

  def default_recipe
    recipes.order(sort_key: :asc).first
  end

  def self.find_by_friendly!(id)
    friendly.find(id)
  end

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  def slug_candidates
    [[:name]]
  end
end
