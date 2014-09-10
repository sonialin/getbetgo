class CreateNominations < ActiveRecord::Migration
  def change
    create_table :nominations do |t|
      t.string :email
      t.string :body
      t.string :sender_name

      t.timestamps
    end
  end
end
