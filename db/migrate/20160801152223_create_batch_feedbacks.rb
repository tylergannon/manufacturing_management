# frozen_string_literal: true
class CreateBatchFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :batch_feedbacks do |t|
      t.date :feedback_date
      %i(overall_impression appearance quantity_impression piece_size spiciness
      saltiness fibrousness chewiness thickness coloration flavor_quality flavor_strength
      aroma_quality aroma_strength).each {|name| t.integer name}

      t.boolean :sellable
      t.references :batch, foreign_key: true
      t.references :user, foreign_key: true
      t.string :notes, limit: 3000

      t.timestamps
    end
  end
end
