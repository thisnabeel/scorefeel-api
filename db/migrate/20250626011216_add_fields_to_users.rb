class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthdate, :date
    add_column :users, :timezone, :string, default: 'UTC'
    add_column :users, :roles, :json, default: []
    
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :timezone
  end
end
