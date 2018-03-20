# frozen_string_literal: true
class Sku < ApplicationRecord
  belongs_to :flavor
  belongs_to :composed_of, class_name: 'Sku', foreign_key: 'composed_of_id'
  has_many :composers, inverse_of: :composed_of, class_name: 'Sku', foreign_key: 'composed_of_id'

  def name
    title
  end

  def flavor_name
    if composed_of.present?
      composed_of.flavor_name
    else
      flavor&.name
    end
  end
end
