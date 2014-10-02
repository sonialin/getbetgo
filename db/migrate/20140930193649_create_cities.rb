class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :region_id
      t.string :full_name
      t.float :latitude
      t.float :longitude
      t.timestamps
    end

    add_index :cities, :full_name
    add_index :cities, :name
  end
end
