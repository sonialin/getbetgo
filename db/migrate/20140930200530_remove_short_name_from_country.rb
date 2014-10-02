class RemoveShortNameFromCountry < ActiveRecord::Migration
  def change
    remove_column :countries, :short_name, :string
  end
end
