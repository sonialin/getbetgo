class AddIndexOnNameToSubcategories < ActiveRecord::Migration
  def change
    add_index :subcategories, :name
  end
end
