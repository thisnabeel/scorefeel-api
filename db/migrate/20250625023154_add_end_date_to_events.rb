class AddEndDateToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :end_date, :date
  end
end
