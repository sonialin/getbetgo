class AddUserRefToModificationRequests < ActiveRecord::Migration
  def change
    add_reference :modification_requests, :user, index: true
  end
end
