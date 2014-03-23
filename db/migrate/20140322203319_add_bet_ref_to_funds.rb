class AddBetRefToFunds < ActiveRecord::Migration
  def change
    add_reference :funds, :bet, index: true
  end
end
