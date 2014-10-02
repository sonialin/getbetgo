class Category < ActiveRecord::Base
	has_many :subcategories
  after_save :update_es_posts

  def update_es_posts
    self.subcategories.joins{posts}.pluck("posts.id").each {|post_id| Resque.enqueue(ElasticsearchApiWorker, post_id)}
  end
	
  def posts
    subcategory_ids = self.subcategories.pluck(:id)
    Post.filter_by_subcategory_ids(subcategory_ids)
  end
end
