class AddPriceToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :price, :decimal
  end
end
