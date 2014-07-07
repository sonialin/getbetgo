class AddCategoryRefToSubcategories < ActiveRecord::Migration
  def change
    add_reference :subcategories, :category, index: true
  end
end
