class CreateGroupsUnregisteredUsers < ActiveRecord::Migration[5.0]
  def up
    create_table :groups_unregist_users, :id => false do |t|
    	t.integer :group_id
    	t.integer :unregist_user_id
    end
    add_index("groups_unregist_users", ["group_id", "unregist_user_id"])
  end

  def end
  	drop_table :groups_unregist_users
  end
end
