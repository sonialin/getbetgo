class RemoveCardFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :card, :integer
  end
end
