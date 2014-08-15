class CreateModificationRequests < ActiveRecord::Migration
  def change
    create_table :modification_requests do |t|
      t.string :body

      t.timestamps
    end
  end
end
