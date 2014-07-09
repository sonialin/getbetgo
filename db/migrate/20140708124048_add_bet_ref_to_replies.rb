class AddBetRefToReplies < ActiveRecord::Migration
  def change
    add_reference :replies, :bet, index: true
  end
end
