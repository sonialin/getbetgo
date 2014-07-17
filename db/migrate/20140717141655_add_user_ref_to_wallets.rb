class AddUserRefToWallets < ActiveRecord::Migration
  def change
    add_reference :wallets, :user, index: true
  end
end
