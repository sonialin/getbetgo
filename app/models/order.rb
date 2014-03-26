class Order < ActiveRecord::Base
	belongs_to :post
	belongs_to :user

	after_save :change_status

	def change_status
		self.post.status = "Paid"
		self.post.save
	end
end
