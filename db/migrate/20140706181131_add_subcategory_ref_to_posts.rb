class AddSubcategoryRefToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :subcategory, index: true
  end
end
