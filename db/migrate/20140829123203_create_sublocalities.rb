class CreateSublocalities < ActiveRecord::Migration
  def change
    create_table :sublocalities do |t|
      t.string :name
      t.string :short_name
      t.integer :locality_id
      t.timestamps
    end

    add_index :sublocalities, :name
    add_index :sublocalities, :short_name
    add_index :sublocalities, :locality_id
  end
end
