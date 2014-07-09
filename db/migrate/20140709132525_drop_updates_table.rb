class DropUpdatesTable < ActiveRecord::Migration
  def up
    drop_table :updates
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
