class AddRedeemedCreditsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :redeemed_credits, :float
  end
end
