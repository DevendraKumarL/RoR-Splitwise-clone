class AddIndexBillIdInDebts < ActiveRecord::Migration[5.0]
  
  def up
  	add_column "debts", "bill_id", :integer
  	add_index "debts", "bill_id"
  end

  def down
  	remove_index "debts", "bill_id"
  	remove_column "debts", "bill_id"
  end
end
