class AddLinkedinToUserInfos < ActiveRecord::Migration
  def change
    add_column :user_infos, :linkedin, :string
  end
end
