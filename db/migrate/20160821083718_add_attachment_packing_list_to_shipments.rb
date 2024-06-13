# frozen_string_literal: true
class AddAttachmentPackingListToShipments < ActiveRecord::Migration
  def self.up
    change_table :shipments do |t|
      t.attachment :packing_list
    end
  end

  def self.down
    remove_attachment :shipments, :packing_list
  end
end
