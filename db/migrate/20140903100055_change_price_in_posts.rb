class ChangePriceInPosts < ActiveRecord::Migration
  def change
  	change_column :posts, :price, :decimal, :precision => 5, :scale => 2
  end
end
