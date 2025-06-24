class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.references :eventable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
