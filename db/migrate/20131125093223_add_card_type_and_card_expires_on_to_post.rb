class AddCardTypeAndCardExpiresOnToPost < ActiveRecord::Migration
  def change
    add_column :posts, :card_type, :string
    add_column :posts, :card_expires_on, :date
  end
end
