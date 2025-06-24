class CreateRelationshipFigures < ActiveRecord::Migration[8.0]
  def change
    create_table :relationship_figures do |t|
      t.references :figure, null: false, foreign_key: true
      t.references :relationship, null: false, foreign_key: true

      t.timestamps
    end
  end
end
