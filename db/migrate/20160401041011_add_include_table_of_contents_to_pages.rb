# frozen_string_literal: true
class AddIncludeTableOfContentsToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :include_table_of_contents, :boolean
  end
end
