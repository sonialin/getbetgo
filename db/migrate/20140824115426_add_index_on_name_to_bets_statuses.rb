class AddIndexOnNameToBetsStatuses < ActiveRecord::Migration
  def change
    add_index :bets_statuses, :name
  end
end
