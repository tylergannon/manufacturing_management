# frozen_string_literal: true
class RemoveForeignKeyFromPhotos < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|
      direction.up do
        remove_foreign_key :photos, column: :owner_id 
      end
    end
  end
end
