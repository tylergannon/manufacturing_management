# frozen_string_literal: true
class AddSortKeyToTumblerRuns < ActiveRecord::Migration[5.0]
  def change
    add_column :tumbler_runs, :sort_key, :integer
  end
end
