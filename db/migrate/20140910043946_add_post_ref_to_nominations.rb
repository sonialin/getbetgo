class AddPostRefToNominations < ActiveRecord::Migration
  def change
    add_reference :nominations, :post, index: true
  end
end
