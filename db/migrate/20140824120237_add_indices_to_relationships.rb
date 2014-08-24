class AddIndicesToRelationships < ActiveRecord::Migration
  def change
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
  end
end
