class AddStatusToFunds < ActiveRecord::Migration
  def change
    add_column :funds, :status, :string
  end
end
