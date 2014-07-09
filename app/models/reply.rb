class Reply < ActiveRecord::Base
	belongs_to :bet
	belongs_to :user
	has_many :proofs, as: :documentable
end
