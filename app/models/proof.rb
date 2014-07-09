class Proof < ActiveRecord::Base
	belongs_to :documentable, polymorphic: true

	has_attached_file :document
end
