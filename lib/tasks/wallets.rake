namespace :wallets do
  desc "initialize wallet credits and coupons"
  task :populate_value => :environment do
    Wallet.all.each do |wallet|
      wallet.credits = 0
      wallet.coupons = 0
      wallet.save
    end
  end
end