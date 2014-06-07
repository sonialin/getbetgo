class Fund < ActiveRecord::Base
	belongs_to :user
	belongs_to :bet

	include PublicActivity::Common

	after_save :change_status

	def change_status
		self.bet.status = "Funded"
		self.bet.save
	end
end
