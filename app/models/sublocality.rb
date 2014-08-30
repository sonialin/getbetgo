class Sublocality < ActiveRecord::Base
  belongs_to :locality
  has_one :place, as: :political
  before_save :replace_comma_with_space

  validates :name, presence: true
  validates :short_name, presence: true
  validates :locality_id, presence: true

  def replace_comma_with_space
    self.name.gsub!(',',' ')
    self.short_name.gsub!(',',' ')
  end

  def posts
    self_posts = self.place.posts.select("posts.id") rescue []
    Post.where("id IN (?)",self_posts)
  end
end
