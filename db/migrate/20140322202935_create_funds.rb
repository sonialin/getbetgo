class CreateFunds < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.float :amount
      t.string :ip_address

      t.timestamps
    end
  end
end
