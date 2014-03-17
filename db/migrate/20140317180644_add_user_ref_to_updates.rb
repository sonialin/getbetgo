class AddUserRefToUpdates < ActiveRecord::Migration
  def change
    add_reference :updates, :user, index: true
  end
end
