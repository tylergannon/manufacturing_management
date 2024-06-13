# frozen_string_literal: true
class CreateDeployments < ActiveRecord::Migration[5.0]
  def change
    create_table :deployments do |t|
      t.datetime :deployed_at, index: true

      t.timestamps
    end
  end
end
