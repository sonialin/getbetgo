class County < ActiveRecord::Base
  belongs_to :state_country, polymorphic: true
  has_one :place, as: :political
  has_many :localities, as: :administrative_area
  before_save :replace_comma_with_space

  validates :name, presence: true
  validates :short_name, presence: true
  validates :state_country_id, presence: true
  validates :state_country_type, presence: true

  def replace_comma_with_space
    self.name.gsub!(',',' ')
    self.short_name.gsub!(',',' ')
  end

  def posts
    self_posts = self.place.posts.select("posts.id") rescue []
    Post.where("id IN (?,?,?)",
                self_posts,
                self.localities.joins("INNER JOIN places ON places.political_id = localities.id AND places.political_type = 'Locality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"),
                self.localities.joins("INNER JOIN sublocalities ON sublocalities.locality_id = localities.id INNER JOIN places ON places.political_id = sublocalities.id AND places.political_type = 'Sublocality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"))
  end
end
