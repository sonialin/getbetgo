class AddTwitterToUserInfos < ActiveRecord::Migration
  def change
    add_column :user_infos, :twitter, :string
  end
end
