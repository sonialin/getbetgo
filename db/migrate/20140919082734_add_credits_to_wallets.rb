class AddCreditsToWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :credits, :float
  end
end
