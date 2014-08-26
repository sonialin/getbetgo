class RemoveStatusFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :status, :string
  end
end
