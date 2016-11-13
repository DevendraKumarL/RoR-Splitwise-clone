class CreateActivities < ActiveRecord::Migration[5.0]
  
  def up
    create_table :activities do |t|
      t.integer :user_id
      t.text :activity_details, :null => false
      t.timestamps
    end
  end

  def down
  	drop_table :activities
  end
end
