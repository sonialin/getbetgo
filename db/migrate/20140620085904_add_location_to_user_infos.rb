class AddLocationToUserInfos < ActiveRecord::Migration
  def change
    add_column :user_infos, :location, :string
  end
end
