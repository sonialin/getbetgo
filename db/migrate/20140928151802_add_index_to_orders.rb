class AddIndexToOrders < ActiveRecord::Migration
  def change
    add_index :orders, :token, :unique => true
  end
end
