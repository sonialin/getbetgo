class Subcategory < ActiveRecord::Base
	belongs_to :category
	has_many :posts
  after_save :update_es_posts

  def update_es_posts
    self.posts.pluck("posts.id").each {|post_id| Resque.enqueue(ElasticsearchApiWorker, post_id)}
  end
end
