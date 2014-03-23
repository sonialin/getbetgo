class Fund < ActiveRecord::Base
	belongs_to :user
	belongs_to :bet

	after_save :change_status

	def change_status
		self.bet.status = "Funded"
		self.bet.save
	end
end
