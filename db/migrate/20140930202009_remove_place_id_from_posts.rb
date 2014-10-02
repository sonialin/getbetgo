class RemovePlaceIdFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :place_id, :integer
  end
end
