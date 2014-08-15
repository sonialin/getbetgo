class AddReplyRefToModificationRequests < ActiveRecord::Migration
  def change
    add_reference :modification_requests, :reply, index: true
  end
end
