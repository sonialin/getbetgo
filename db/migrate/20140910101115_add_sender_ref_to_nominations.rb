class AddSenderRefToNominations < ActiveRecord::Migration
  def change
    add_reference :nominations, :sender, references: :users, index: true
  end
end
