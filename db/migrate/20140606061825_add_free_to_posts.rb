class AddFreeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :free, :boolean
  end
end
