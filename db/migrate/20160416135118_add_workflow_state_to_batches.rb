# frozen_string_literal: true
class AddWorkflowStateToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :workflow_state, :string, index: true
  end
end
