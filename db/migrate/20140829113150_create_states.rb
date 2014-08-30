# state / region / administrative_area_level_1
class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :short_name
      t.integer :country_id
      t.timestamps
    end

    add_index :states, :name
    add_index :states, :short_name
    add_index :states, :country_id
  end
end
