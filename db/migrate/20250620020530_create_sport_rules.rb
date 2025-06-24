class CreateSportRules < ActiveRecord::Migration[8.0]
  def change
    create_table :sport_rules do |t|
      t.string :title
      t.text :summary
      t.text :body
      t.references :sport, null: false, foreign_key: true

      t.timestamps
    end
  end
end
