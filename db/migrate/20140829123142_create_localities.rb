# city / locality
class CreateLocalities < ActiveRecord::Migration
  def change
    create_table :localities do |t|
      t.string :name
      t.string :short_name
      t.references :administrative_area, polymorphic: true
      t.timestamps
    end

    add_index :localities, :name
    add_index :localities, :short_name
    add_index :localities, [:administrative_area_type, :administrative_area_id], :name => "index_localities_on_administrative_area"
  end
end
