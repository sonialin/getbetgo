class Wallet < ActiveRecord::Base
	belongs_to :user

	def amount
		self.credits + self.coupons
	end

	def load_credits(credits)
		self.credits += credits
		self.save
	end
end
