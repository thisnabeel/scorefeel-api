class CreatePictures < ActiveRecord::Migration[8.0]
  def change
    create_table :pictures do |t|
      t.string :picturable_type, null: false
      t.bigint :picturable_id, null: false
      t.string :caption
      t.string :image_url
      t.string :storage_key
      t.boolean :cover, default: false

      t.timestamps
    end
    
    add_index :pictures, [:picturable_type, :picturable_id]
  end
end
