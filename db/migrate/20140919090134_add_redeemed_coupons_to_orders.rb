class AddRedeemedCouponsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :redeemed_coupons, :float
  end
end
