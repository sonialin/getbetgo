class RemoveIndexOnUserpostFromBets < ActiveRecord::Migration
  def change
    remove_index :bets, :name => "udx_bets_on_user_and_post"
  end
end
