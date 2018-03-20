# frozen_string_literal: true
class AddReceiveConfirmationMailingsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :receive_confirmation_mailings, :boolean, {default: true}
  end
end
