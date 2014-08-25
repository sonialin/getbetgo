class AddIndexOnNameToPostsStatuses < ActiveRecord::Migration
  def change
    add_index :posts_statuses, :name
  end
end
