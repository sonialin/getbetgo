class AddBodyToBets < ActiveRecord::Migration
  def change
    add_column :bets, :body, :string
  end
end
