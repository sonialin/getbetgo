class Reply < ActiveRecord::Base
	belongs_to :bet
	belongs_to :user
	has_one :modification_request
	has_many :proofs, as: :documentable
end
