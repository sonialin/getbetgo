class AddPostRefToUpdates < ActiveRecord::Migration
  def change
    add_reference :updates, :post, index: true
  end
end
