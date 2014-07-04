class RemoveAttachmentAvatarFromUsers < ActiveRecord::Migration
  def change
    drop_attached_file :users, :avatar
  end
end
