class Order < ActiveRecord::Base
	belongs_to :user
	belongs_to :bet
	belongs_to :post

	include Tokenable

	after_create :change_status

	def change_status
		self.bet.status = "Selected"
		self.bet.save
	end
end
