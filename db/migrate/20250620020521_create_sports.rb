class CreateSports < ActiveRecord::Migration[8.0]
  def change
    create_table :sports do |t|
      t.string :title
      t.references :sport, null: true, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
