# frozen_string_literal: true
class AddCancellationReasonToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :rejection_reason, :string, limit: 2000
    add_column :batches, :cancellation_reason, :string, limit: 2000
  end
end
