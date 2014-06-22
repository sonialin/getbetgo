class AddGithubToUserInfos < ActiveRecord::Migration
  def change
    add_column :user_infos, :github, :string
  end
end
