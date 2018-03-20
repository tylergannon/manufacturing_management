# frozen_string_literal: true
class AddRoleToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role, :integer

    reversible do |direction|
      direction.up do
        User.update_all role: 3
        User.where(email: ['tyler@manufacturing.com', 'tyler@aprilseven.co']).
          update_all role: 1
      end
    end
  end
end
