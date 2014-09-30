class AddPrivateToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :private, :boolean
  end
end
