class CreateBulletPoints < ActiveRecord::Migration[8.0]
  def change
    create_table :bullet_points do |t|
      t.text :body
      t.string :bullet_pointable_type
      t.integer :bullet_pointable_id
      t.integer :position, default: 0

      t.timestamps
    end
    
    add_index :bullet_points, [:bullet_pointable_type, :bullet_pointable_id]
  end
end
