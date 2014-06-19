class AddUserRefToUserInfos < ActiveRecord::Migration
  def change
    add_reference :user_infos, :user, index: true
  end
end
