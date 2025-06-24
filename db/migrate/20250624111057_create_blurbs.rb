class CreateBlurbs < ActiveRecord::Migration[8.0]
  def change
    create_table :blurbs do |t|
      t.string :title
      t.text :description
      t.string :blurbable_type
      t.integer :blurbable_id
      t.boolean :starred, default: true

      t.timestamps
    end
    
    add_index :blurbs, [:blurbable_type, :blurbable_id]
  end
end
