class AddUserRefToPaypalRecipientAccounts < ActiveRecord::Migration
  def change
    add_reference :paypal_recipient_accounts, :user, index: true
  end
end
