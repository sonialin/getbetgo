class Category < ActiveRecord::Base
	has_many :subcategories
	
  def posts
    subcategory_ids = self.subcategories.pluck(:id)
    Post.filter_by_subcategory_ids(subcategory_ids)
  end
end
