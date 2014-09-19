class RemoveCreditFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :credit, :float
  end
end
