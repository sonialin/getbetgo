class Fund < ActiveRecord::Base
	belongs_to :user
	belongs_to :bet

	include PublicActivity::Common
end
