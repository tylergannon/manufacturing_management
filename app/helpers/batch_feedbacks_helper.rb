# frozen_string_literal: true
module BatchFeedbacksHelper
  def feedback_options(_batch_feedback, attribute)
    attribute = attribute.to_s
    values = BatchFeedback.send(attribute.pluralize).keys
    values.map do |v|
      [v, v.to_s.titleize]
    end
  end
end
