class AddReceiverRefToNominations < ActiveRecord::Migration
  def change
    add_reference :nominations, :receiver, references: :users, index: true
  end
end
