# frozen_string_literal: true
class BatchFeedback < ApplicationRecord
  include BatchFeedbackEnums
  belongs_to :batch, touch: true
  belongs_to :user

  ENUMS = %i(overall_impression appearance quantity_impression piece_size spiciness
             saltiness fibrousness chewiness thickness coloration flavor_quality flavor_strength
             aroma_quality aroma_strength).freeze

  default_value_for :aroma_strength, 3
  default_value_for :aroma_quality, 5
  default_value_for :flavor_strength, 3
  default_value_for :flavor_quality, 5
  default_value_for :coloration, 2
  default_value_for :thickness, 3
  default_value_for :chewiness, 3
  default_value_for :fibrousness, 1
  default_value_for :saltiness, 3
  default_value_for :spiciness, 3
  default_value_for :piece_size, 3
  default_value_for :quantity_impression, 2
  default_value_for :appearance, 3
  default_value_for :overall_impression, 4
  default_value_for :sellable, true

  default_value_for :feedback_date do
    Date.today
  end
end
