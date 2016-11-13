class CreateUsers < ActiveRecord::Migration[5.0]
  def up
    create_table :users do |t|
      t.string "username", :limit => 25, :null => false
      t.string "email", :null => false
      t.string "password", :null => false, :limit => 25
      t.string "phone", :null => false, :limit => 10
      t.string "image", :null => true, :default => ''
      t.timestamps
    end
  end

  def down
  	drop_table :users
  end
end
