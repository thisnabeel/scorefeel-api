class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :title
      t.text :summary

      t.timestamps
    end
  end
end
