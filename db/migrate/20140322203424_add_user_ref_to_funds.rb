class AddUserRefToFunds < ActiveRecord::Migration
  def change
    add_reference :funds, :user, index: true
  end
end
