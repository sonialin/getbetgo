class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.float :amount

      t.timestamps
    end
  end
end
