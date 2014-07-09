class AddReplyRefToProofs < ActiveRecord::Migration
  def change
    add_reference :proofs, :reply, index: true
  end
end
