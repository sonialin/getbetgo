class RemoveFreeFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :free, :boolean
  end
end
