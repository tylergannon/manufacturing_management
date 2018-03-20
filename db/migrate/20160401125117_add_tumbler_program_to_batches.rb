# frozen_string_literal: true
class AddTumblerProgramToBatches < ActiveRecord::Migration[5.0]
  def change
    add_reference :batches, :tumbler_program, foreign_key: true

    reversible do |dir|
      dir.up do
        Batch.update_all tumbler_program_id: TumblerProgram.order(:id).last&.id
      end
    end

    remove_reference :tumbler_runs, :tumbler_program, foreign_key: true
  end
end
