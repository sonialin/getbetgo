class RemoveResultFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :result, :string
  end
end
