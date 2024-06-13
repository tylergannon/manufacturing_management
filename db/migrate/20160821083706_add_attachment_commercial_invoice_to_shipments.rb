# frozen_string_literal: true
class AddAttachmentCommercialInvoiceToShipments < ActiveRecord::Migration
  def self.up
    change_table :shipments do |t|
      t.attachment :commercial_invoice
    end
  end

  def self.down
    remove_attachment :shipments, :commercial_invoice
  end
end
