class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :short_name
      t.timestamps
    end

    add_index :countries, :name
    add_index :countries, :short_name
  end
end
