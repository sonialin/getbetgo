class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.text :biography

      t.timestamps
    end
  end
end
