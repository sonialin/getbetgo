class RemoveIpAddressFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :ip_address, :string
  end
end
