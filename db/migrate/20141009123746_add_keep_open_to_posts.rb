class AddKeepOpenToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :keep_open, :boolean
  end
end
