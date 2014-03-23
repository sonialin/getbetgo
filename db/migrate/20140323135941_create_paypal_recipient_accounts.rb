class CreatePaypalRecipientAccounts < ActiveRecord::Migration
  def change
    create_table :paypal_recipient_accounts do |t|
      t.string :email

      t.timestamps
    end
  end
end
