# county / administrative_area_level_2
class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :name
      t.string :short_name
      t.references :state_country, polymorphic: true
      t.timestamps
    end

    add_index :counties, :name
    add_index :counties, :short_name
    add_index :counties, [:state_country_type, :state_country_id]
  end
end
