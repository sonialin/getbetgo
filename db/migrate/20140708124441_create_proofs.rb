class CreateProofs < ActiveRecord::Migration
  def change
    create_table :proofs do |t|

      t.timestamps
    end
  end
end
