class UserInfo < ActiveRecord::Base
	belongs_to :user

	has_attached_file :cover_photo, :styles => { :big => '600', :medium => "400x200#" }, :default_url => "http://placehold.it/400x200"
end
