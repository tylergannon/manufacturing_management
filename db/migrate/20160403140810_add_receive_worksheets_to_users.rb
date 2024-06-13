# frozen_string_literal: true
class AddReceiveWorksheetsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :receive_worksheets, :boolean
    reversible do |direction|
      direction.up do
        User.update_all receive_worksheets: true
      end
    end
  end
end
