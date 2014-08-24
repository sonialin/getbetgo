class AddIndexOnStatusIdToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :status_id
  end
end
