class AddIndicesToBets < ActiveRecord::Migration
  def change
    add_index :bets, :post_id
    add_index :bets, :user_id
    add_index :bets, :status_id
  end
end
