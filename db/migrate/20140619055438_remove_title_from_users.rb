class RemoveTitleFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :title, :string
  end
end
