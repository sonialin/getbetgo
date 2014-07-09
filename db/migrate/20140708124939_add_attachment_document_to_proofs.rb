class AddAttachmentDocumentToProofs < ActiveRecord::Migration
  def self.up
    change_table :proofs do |t|
      t.attachment :document
    end
  end

  def self.down
    drop_attached_file :proofs, :document
  end
end
