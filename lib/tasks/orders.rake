namespace :orders do
  desc "delete orders without bet_id"
  task :delete => :environment do
    Order.all.each do |order|
    	if order.bet_id == nil
    		order.destroy
    	end
    end
  end
end