class AddWebsiteToUserInfos < ActiveRecord::Migration
  def change
    add_column :user_infos, :website, :string
  end
end
