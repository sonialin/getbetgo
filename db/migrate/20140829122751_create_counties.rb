# county / administrative_area_level_2
class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :name
      t.string :short_name
      t.integer :state_id
      t.timestamps
    end

    add_index :counties, :name
    add_index :counties, :short_name
    add_index :counties, :state_id
  end
end
