class AddUniquenessConstraintToBets < ActiveRecord::Migration
  add_index  :bets, [:user_id, :post_id],
    :name => "udx_bets_on_user_and_post", :unique => true
end
