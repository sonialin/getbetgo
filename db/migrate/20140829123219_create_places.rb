class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :google_api_place_id
      t.references :political, polymorphic: true
      t.timestamps
    end

    add_index :places, :google_api_place_id
    add_index :places, [:political_type, :political_id], :name => "index_places_on_political"
  end
end
