class Update < ActiveRecord::Base
	belongs_to :bet
	belongs_to :user
	belongs_to :post

	validates :body, presence: true

	after_save :change_status

	def change_status
		self.bet.status = "Submitted"
		self.bet.save
	end
end
