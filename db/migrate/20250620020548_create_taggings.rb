class CreateTaggings < ActiveRecord::Migration[8.0]
  def change
    create_table :taggings do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :tagable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
