namespace :bets do
  desc "populating status_id from status"
  task :populate_status => :environment do
    Bet.all.each do |bet|
      bet.update_column(:status_id, ::Bets::Status.find_by_name(bet.read_attribute(:status)).id)
    end
  end
end