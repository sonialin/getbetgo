class Locality < ActiveRecord::Base
  belongs_to :administrative_area, polymorphic: true
  has_many :sublocalities
  has_one :place, as: :political
  before_save :replace_comma_with_space

  validates :name, presence: true
  validates :short_name, presence: true
  validates :administrative_area_id, presence: true
  validates :administrative_area_type, presence: true

  def replace_comma_with_space
    self.name.gsub!(',',' ')
    self.short_name.gsub!(',',' ')
  end

  def posts
    self_posts = self.place.posts.select("posts.id") rescue []
    Post.where("id IN (?,?)",
                self_posts,
                self.sublocalities.joins("INNER JOIN places ON places.political_id = sublocalities.id AND places.political_type = 'Sublocality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"))
  end
end
