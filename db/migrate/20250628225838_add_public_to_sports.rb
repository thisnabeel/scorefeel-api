class AddPublicToSports < ActiveRecord::Migration[8.0]
  def change
    add_column :sports, :public, :boolean, default: false
  end
end
