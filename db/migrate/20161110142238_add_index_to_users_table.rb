class AddIndexToUsersTable < ActiveRecord::Migration[5.0]
  
  def up
  	add_index("users", "username", :unique => true)
  	add_index("users", "email", :unique => true)
  	add_index("users", "phone", :unique => true)
  end

  def down
  	remove_index("users", "username")
  	remove_index("users", "email")
  	remove_index("users", "phone")
  end
end
