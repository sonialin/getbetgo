class AddPostIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :post_id, :integer
    add_index :orders, :post_id
  end
end
