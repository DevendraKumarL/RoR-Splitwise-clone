class CreateDebts < ActiveRecord::Migration[5.0]
  
  def up
    create_table :debts do |t|
      t.integer :member1, :null => false
      t.integer :member2, :null => false
      t.float :owes_amount, :default => 0.0
      t.boolean :unregist_mem1, :default => true
      t.boolean :unregist_mem2, :default => true
      t.integer :group_id
      t.timestamps
    end
    add_index("debts", "group_id")
  end

  def down
  	drop_table :debts
  end
end
