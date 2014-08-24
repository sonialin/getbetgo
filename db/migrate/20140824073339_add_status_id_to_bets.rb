class AddStatusIdToBets < ActiveRecord::Migration
  def change
    add_column :bets, :status_id, :integer
  end
end
