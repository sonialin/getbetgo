class Post < ActiveRecord::Base
	belongs_to :user
  # validates :user_id, presence: true

  attr_accessible :title, :description, :image_url, :price, :quantity
end
