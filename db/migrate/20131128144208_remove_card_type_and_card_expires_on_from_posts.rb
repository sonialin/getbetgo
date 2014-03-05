class RemoveCardTypeAndCardExpiresOnFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :card_type, :string
    remove_column :posts, :card_expires_on, :date
  end
end
