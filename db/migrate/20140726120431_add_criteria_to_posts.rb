class AddCriteriaToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :criteria, :string
  end
end
