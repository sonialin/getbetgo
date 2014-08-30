class AddPlaceIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :place_id, :integer
    add_index :posts, :place_id
  end
end
