class RemoveTimeFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :time, :datetime
  end
end
