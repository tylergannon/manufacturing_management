# frozen_string_literal: true
class AddBatchToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_reference :photos, :batch, foreign_key: true
  end
end
