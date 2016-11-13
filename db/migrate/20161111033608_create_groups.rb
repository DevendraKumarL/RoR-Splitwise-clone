class CreateGroups < ActiveRecord::Migration[5.0]
  
  def up
    create_table :groups do |t|
      t.string :name, :null => false
      t.text :description, :null => true
      t.integer :user_id
      t.timestamps
  	end
    add_index("groups", "user_id")
  end

  def down
  	drop_table :groups
  end
end
