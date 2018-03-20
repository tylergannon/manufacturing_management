class RemoveFlavorFromBatches < ActiveRecord::Migration[5.0]
  def change
    remove_reference :batches, :flavor
  end
end
