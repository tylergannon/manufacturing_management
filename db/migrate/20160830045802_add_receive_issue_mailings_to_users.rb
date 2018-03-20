# frozen_string_literal: true
class AddReceiveIssueMailingsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :receive_issue_mailings, :boolean
  end
end
