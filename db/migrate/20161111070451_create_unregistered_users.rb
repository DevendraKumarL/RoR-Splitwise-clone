class CreateUnregisteredUsers < ActiveRecord::Migration[5.0]
  
  def up
    create_table :unregist_users do |t|
      t.string :name, :limit => 25,  :null => false
      t.string :email, :null => false
      t.boolean :registered, :default => false
      t.timestamps
    end
  end

  def down
  	drop_table :unregist_users
  end
end
