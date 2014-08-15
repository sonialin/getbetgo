class ModificationRequest < ActiveRecord::Base
	belongs_to :reply
	belongs_to :user

	after_save :change_status

	def change_status
		self.reply.bet.status = "Awaiting Modification"
		self.reply.bet.save
	end
end
