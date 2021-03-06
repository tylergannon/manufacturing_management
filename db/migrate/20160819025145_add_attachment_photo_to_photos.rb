# frozen_string_literal: true
class AddAttachmentPhotoToPhotos < ActiveRecord::Migration
  def self.up
    change_table :photos do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :photos, :photo
  end
end
