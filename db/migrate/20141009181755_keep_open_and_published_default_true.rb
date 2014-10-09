class KeepOpenAndPublishedDefaultTrue < ActiveRecord::Migration
  def change
    change_column :posts, :keep_open, :boolean, :default => true
    change_column :posts, :published, :boolean, :default => true
  end
end
