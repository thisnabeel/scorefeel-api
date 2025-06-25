class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.integer :position, default: 0
      t.integer :level, default: 0
      t.string :pageable_type
      t.integer :pageable_id

      t.timestamps
    end
    
    add_index :pages, :slug, unique: true
    add_index :pages, [:pageable_type, :pageable_id]
    add_index :pages, [:position, :level]
  end
end
