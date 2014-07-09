class Proof < ActiveRecord::Base
	belongs_to :reply

	has_attached_file :document
end
