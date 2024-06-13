# frozen_string_literal: true
class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    rename_column :batches, :notes, :_notes

    create_table :notes do |t|
      t.references :user, foreign_key: true
      t.text :notes
      t.integer :noteworthy_id
      t.string :noteworthy_type

      t.timestamps
    end

    reversible do |direction|
      direction.up do
        user = User.find_by(email: 'tyler@manufacturing.com')
        Batch.where.not(_notes: nil).each do |batch|
          batch.notes.create notes: batch._notes, user: user
        end
      end

      direction.down do
        Batch.joins(:notes).where.not(notes: {id: nil}).distinct.each do |batch|
          batch.update_column '_notes', batch.notes.unscoped.order(id: :asc).first.notes
        end
      end
    end

    remove_column :batches, :_notes, :text
  end
end
