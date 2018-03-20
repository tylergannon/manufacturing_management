# frozen_string_literal: true
require 'csv'
module BatchPresentation
  extend ActiveSupport::Concern

  CSV_ATTRIBUTES = [:production_date,
                    :expiration_date,
                    :ships_on,
                    :slug,
                    :net_weight_sellable,
                    :net_weight_seconds,
                    :fresh_primary_ingredient_loss,
                    :gross_fresh_primary_ingredient,
                    :pouches_produced,
                    :workflow_state,
                    :amount_of_primary_ingredient,
                    :cartons_packed,
                    :harvest_thick,
                    :harvest_thin,
                    :harvest_good,
                    :harvest_scraps,
                    :unusable_thin_product,
                    :unusable_thick_product,
                    :unusable_other_product].freeze

  included do
    def self.primary_ingredient_performance(start_weeks, end_weeks=0)
      start_date = start_weeks.weeks.ago.to_date
      end_date   = end_weeks.weeks.ago.to_date
      batches = Batch.where.not(pouches_produced: nil).
                      where.not(gross_fresh_primary_ingredient: nil).
                      where(production_date: (start_date..end_date))
      puts "kg primary_ingredient per pouch"
      primary_ingredient = batches.sum(:gross_fresh_primary_ingredient)
      pouches = batches.sum(:pouches_produced)
      {
        primary_ingredient_kg: primary_ingredient,
        pouches: pouches,
        start_date: start_date,
        end_date: end_date,
        kg_primary_ingredient_per_pouch: (primary_ingredient/pouches),
        kg_primary_ingredient_per_pallet: (1920*primary_ingredient/pouches)
      }
    end

    def self.to_csv
      CSV.generate(headers: true) do |csv|
        csv << CSV_ATTRIBUTES.map { |t| t.to_s.titleize }

        all.each do |batch|
          csv << CSV_ATTRIBUTES.map { |attr| batch.send(attr) }
        end
        csv
      end
    end
  end

  def friendly_production_date
    if production_date <= 1.year.ago
      production_date.strftime('%b %-d, %Y')
    else
      production_date.strftime('%b %-d')
    end
  end

  def ships_on
    shipment&.ships_on
  end

  def collection_options
    [id, long_name]
  end

  def formatted_expiration_date
    expiration_date&.strftime('%d%b%Y')&.upcase
  end

  def as_json(*_args)
    {
      id: id,
      batch_number: batch_number,
      name: long_name
    }
  end

  def can_print_labels?
    shipment.present? && gross_fresh_primary_ingredient.to_i.positive?
  end

  def labels_error_message
    error_name =
      if shipment.present?
        'no_primary_ingredient_quantity'
      elsif gross_fresh_primary_ingredient
        'no_shipment'
      else
        'no_primary_ingredient_or_shipment'
      end
    I18n.t("error.batch.labels_error.#{error_name}")
  end

  def name
    batch_number
  end

  def long_name
    "#{batch_number} #{flavor.name} #{friendly_production_date}"
  end
end
