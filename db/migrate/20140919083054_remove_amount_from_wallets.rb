class RemoveAmountFromWallets < ActiveRecord::Migration
  def change
    remove_column :wallets, :amount, :float
  end
end
