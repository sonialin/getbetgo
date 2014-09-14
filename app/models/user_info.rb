class UserInfo < ActiveRecord::Base
	belongs_to :user

	has_attached_file :cover_photo, :styles => { :big => '600', :medium => "400x200#" }
	has_attached_file :avatar, :styles => { :medium => "300x300#", :thumb => "100x100#" }, 
										:default_url => "http://res.cloudinary.com/dxytnnzk9/image/upload/v1408186172/fw-avatar-grey_hx1dgp.png"

  def location_tokenize
    [{:id => self.location, :name => self.location}]
  end
end
