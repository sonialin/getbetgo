class Reply < ActiveRecord::Base
	belongs_to :bet
	belongs_to :user
	has_one :modification_request
	has_many :proofs, as: :documentable

	validates :body, presence: true

	def change_bet_status
		self.bet.status_id = 5
		self.bet.save
	end
end
