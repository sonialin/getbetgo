namespace :orders do
  desc "delete orders without bet_id"
  task :delete => :environment do
    Order.all.each do |order|
    	if order.bet_id == nil
    		order.destroy
    	end
    end
  end

  desc "set redeemed values to 0 if nil"
  task :populate_redeemed_values => :environment do
  	Order.all.each do |order|
    	if order.redeemed_credits == nil or order.redeemed_coupons == nil
    		if order.redeemed_credits == nil
    			order.redeemed_credits = 0
    		end
    		if order.redeemed_coupons == nil
    			order.redeemed_coupons = 0
    		end
    		order.save
    	end
    end
  end

  desc "set token if nil"
  task :populate_tokens => :environment do
    Order.all.each do |order|
      if order.token == nil
        order.token = SecureRandom.hex(4).upcase
        order.save
      end
    end
  end
end