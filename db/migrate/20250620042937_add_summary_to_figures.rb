class AddSummaryToFigures < ActiveRecord::Migration[8.0]
  def change
    add_column :figures, :summary, :text
  end
end
