class RenameDateToStartDateInEvents < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :date, :start_date
  end
end
