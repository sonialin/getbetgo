class AddServiceToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :service, :string
  end
end
