class CreatePaypalNotifications < ActiveRecord::Migration
  def change
    create_table :paypal_notifications do |t|
      t.json :params
      t.integer :order_id
      t.string :txn_id

      t.timestamps
    end
  end
end
