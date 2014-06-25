class UserInfo < ActiveRecord::Base
	belongs_to :user

	has_attached_file :cover_photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
