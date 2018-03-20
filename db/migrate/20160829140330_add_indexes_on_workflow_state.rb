# frozen_string_literal: true
class AddIndexesOnWorkflowState < ActiveRecord::Migration[5.0]
  def change
    add_index :batches, :workflow_state
    add_index :shipments, :workflow_state
  end
end
