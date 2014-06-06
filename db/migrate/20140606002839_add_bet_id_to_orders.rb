class AddBetIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :bet_id, :integer
    add_index :orders, :bet_id
  end
end
