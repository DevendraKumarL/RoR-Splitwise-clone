class ChangeNameColumnInUnregistUser < ActiveRecord::Migration[5.0]
  
  def up
  	change_column "unregist_users", "email", :string, :default => '', :null => true
  	change_column "unregist_users", "name", :string, :limit => 25, :default => 'Anonymous', :null => true
  end

  def down
  	change_column "unregist_users", "name", :string, :limit => 25, :null => false
  	change_column "unregist_users", "email", :string, :default => false, :nul => false
  end
end
