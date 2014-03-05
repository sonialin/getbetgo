class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.float :amount
      t.integer :card
      t.datetime :time
      t.integer :user_id
      t.string :result

      t.timestamps
    end
  end
end
