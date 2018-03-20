# frozen_string_literal: true
module BatchScopes
  extend ActiveSupport::Concern
  def ingredients
    Rails.cache.fetch "#{cache_key}/ingredients_query" do
      query = <<-EOQ
        SELECT ingredients.*, recipe_ingredients.grams_per_kilo_primary_ingredient,
              recipe_ingredients.grams_per_kilo_primary_ingredient * ? as quantity
        FROM ingredients
          INNER JOIN recipe_ingredients
            ON ingredients.id = recipe_ingredients.ingredient_id
          INNER JOIN recipes
            ON recipe_ingredients.recipe_id = recipes.id
        WHERE recipes.id = ?
        ORDER BY quantity DESC
      EOQ
      Ingredient.find_by_sql [query, gross_fresh_primary_ingredient, recipe_id]
    end
  end

  included do
    default_scope -> { where.not(workflow_state: 'cancelled') }

    scope :current, lambda {
      order(production_date: :desc).where(
        workflow_state: %w(started inquest qa accepted),
        production_date: (1.month.ago..1.day.from_now)
      )
    }

    scope :with_flavor, lambda {
      includes(recipe: :flavor)
    }

    scope :future, lambda { |days|
      order(production_date: :asc)
        .where(production_date: (Date.tomorrow..days.to_i.days.from_now))
    }

    scope :recent, lambda {
      order(production_date: :desc)
        .where(production_date: (12.months.ago..Date.today))
    }

    scope :listing, lambda {
      with_flavor
        .order(production_date: :desc).where.not(workflow_state: 'cancelled')
    }

    def self.find_by_friendly_with_associations!(friendly_id)
      unscoped.with_flavor.includes(:notes, :shipment).find_by slug: friendly_id.upcase
    end

    def self.find_by_friendly!(friendly_id)
      unscoped.find_by slug: friendly_id.upcase
    end

    def self.shippable
      with_flavor.where(shipment_id: nil).in_terminal_state
    end
  end
end
