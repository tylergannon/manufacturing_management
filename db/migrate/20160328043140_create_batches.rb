# frozen_string_literal: true
class CreateBatches < ActiveRecord::Migration[5.0]
  def change
    create_table :batches do |t|
      t.references :flavor, foreign_key: true
      t.date :production_date
      t.references :manager_on_duty, foreign_key: false

      t.timestamps
    end
  end
end
