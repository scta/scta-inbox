class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :notifications, :source, :motivation
  end
end
