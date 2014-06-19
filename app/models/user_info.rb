class UserInfo < ActiveRecord::Base
	belongs_to :user

	validates :biography, presence: true
end
