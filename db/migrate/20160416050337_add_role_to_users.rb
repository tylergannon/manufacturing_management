# frozen_string_literal: true
class AddRoleToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role, :integer

    reversible do |direction|
      direction.up do
        User.update_all role: 3
        User.where(email: ['nobody@manufacturing.com']).
          update_all role: 1
      end
    end
  end
end
