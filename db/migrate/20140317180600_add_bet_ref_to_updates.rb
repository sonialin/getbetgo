class AddBetRefToUpdates < ActiveRecord::Migration
  def change
    add_reference :updates, :bet, index: true
  end
end
