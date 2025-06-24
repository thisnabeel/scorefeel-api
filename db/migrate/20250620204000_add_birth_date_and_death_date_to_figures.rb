class AddBirthDateAndDeathDateToFigures < ActiveRecord::Migration[8.0]
  def change
    add_column :figures, :birth_date, :date
    add_column :figures, :death_date, :date
  end
end
