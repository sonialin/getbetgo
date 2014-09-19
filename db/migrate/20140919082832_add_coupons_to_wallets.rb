class AddCouponsToWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :coupons, :float
  end
end
