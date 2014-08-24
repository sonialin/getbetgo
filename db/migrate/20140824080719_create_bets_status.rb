class CreateBetsStatus < ActiveRecord::Migration
  def change
    create_table :bets_statuses do |t|
      t.string :name
    end


  ::Bets::Status.create(:name => "Open")
  ::Bets::Status.create(:name => "Selected")
  ::Bets::Status.create(:name => "Submitted")
  ::Bets::Status.create(:name => "Awaiting Modification")
  ::Bets::Status.create(:name => "Modified")
  ::Bets::Status.create(:name => "Credited")
  ::Bets::Status.create(:name => "Funded")
  end
end
