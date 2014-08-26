class RemoveStatusFromBets < ActiveRecord::Migration
  def change
    remove_column :bets, :status, :string
  end
end
