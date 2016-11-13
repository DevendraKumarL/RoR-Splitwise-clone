class CreateBills < ActiveRecord::Migration[5.0]
  
  def up
    create_table :bills do |t|
      t.string :name, :null => false
      t.text :descrption, :null => true
      t.float :total_amount, :null => false
      t.string :split_method, :default => 'equally', :null => false
      t.integer :group_id
      t.timestamps
    end
    add_index("bills", "group_id")
  end

  def down
    drop_table :bills
  end
end
