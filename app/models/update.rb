class Update < ActiveRecord::Base
	belongs_to :bet
	belongs_to :user
	belongs_to :post

	validates :body, presence: true
end
