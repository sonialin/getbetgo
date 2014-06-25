class AddAttachmentCoverPhotoToUserInfos < ActiveRecord::Migration
  def self.up
    change_table :user_infos do |t|
      t.attachment :cover_photo
    end
  end

  def self.down
    drop_attached_file :user_infos, :cover_photo
  end
end
