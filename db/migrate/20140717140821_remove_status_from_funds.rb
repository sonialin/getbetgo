class RemoveStatusFromFunds < ActiveRecord::Migration
  def change
    remove_column :funds, :status, :string
  end
end
