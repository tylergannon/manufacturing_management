# frozen_string_literal: true
class FulfillmentWarehouse < ApplicationRecord
  has_many :purchase_orders
  validates :name, presence: true
end
