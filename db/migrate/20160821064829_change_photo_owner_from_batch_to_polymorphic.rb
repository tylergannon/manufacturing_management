# frozen_string_literal: true
class ChangePhotoOwnerFromBatchToPolymorphic < ActiveRecord::Migration[5.0]
  def change
    remove_index :photos, :batch_id
    rename_column :photos, :batch_id, :owner_id
    remove_column :photos, :batch_feedback_id, :integer, index: true
    add_column :photos, :owner_type, :string
    add_index :photos, [:owner_id, :owner_type]

    reversible do |direction|
      direction.up do
        Photo.update_all owner_type: 'Batch'
      end
    end
  end
end
