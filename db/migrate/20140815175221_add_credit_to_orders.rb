class AddCreditToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :credit, :float
  end
end
