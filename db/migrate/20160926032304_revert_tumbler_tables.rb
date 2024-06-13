# frozen_string_literal: true
require_relative '20160411090333_add_max_tumbler_run_size_to_configurations'
require_relative '20160401125117_add_tumbler_program_to_batches'
require_relative '20160401122330_add_tumbler_run_size_to_batch'
require_relative '20160401121920_add_sort_key_to_tumbler_runs'
require_relative '20160328063837_create_tumbler_runs'


class RevertTumblerTables < ActiveRecord::Migration[5.0]
  def change
    revert AddMaxTumblerRunSizeToConfigurations
    revert AddTumblerProgramToBatches
    revert AddTumblerRunSizeToBatch
    revert AddSortKeyToTumblerRuns
    revert CreateTumblerRuns
  end
end
