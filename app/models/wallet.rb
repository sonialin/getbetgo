class Wallet < ActiveRecord::Base
	belongs_to :user

	def amount
		self.credits + self.coupons
	end
end
