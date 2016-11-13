class AddPasswordDigestToUser < ActiveRecord::Migration[5.0]
  
  def up
  	remove_column "users", "password"
  	add_column "users", "password_digest", :string, :null => false
  end

  def down
  	remove_column "users", "password_digest"
  	add_column "users", "password", :string, :limit => 25, :null => false
  end
end
