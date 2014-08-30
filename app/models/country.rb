class Country < ActiveRecord::Base
  has_many :states
  has_many :counties, as: :state_country
  has_many :localities, as: :administrative_area
  has_one :place, as: :political
  before_save :replace_comma_with_space

  validates :name, presence: true
  validates :short_name, presence: true

  def replace_comma_with_space
    self.name.gsub!(',',' ')
    self.short_name.gsub!(',',' ')
  end

  def posts
    self_posts = self.place.posts.select("posts.id") rescue []
    Post.where("id IN (?,?,?,?,?,?,?,?,?,?,?,?)",
                self_posts,
                self.states.joins("INNER JOIN places ON places.political_id = states.id AND places.political_type = 'State' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"),
                self.states.joins("INNER JOIN counties ON states.id = counties.state_country_id AND counties.state_country_type = 'State' INNER JOIN places ON places.political_id = counties.id AND places.political_type = 'County' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"),
                self.states.joins("INNER JOIN localities ON states.id = localities.administrative_area_id AND localities.administrative_area_type = 'State' INNER JOIN places ON places.political_id = localities.id AND places.political_type = 'Locality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"),
                self.states.joins("INNER JOIN counties ON states.id = counties.state_country_id AND counties.state_country_type = 'State' INNER JOIN localities ON counties.id = localities.administrative_area_id AND localities.administrative_area_type = 'County' INNER JOIN places ON places.political_id = localities.id AND places.political_type = 'Locality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"),
                self.states.joins("INNER JOIN localities ON states.id = localities.administrative_area_id AND localities.administrative_area_type = 'State' INNER JOIN sublocalities ON sublocalities.locality_id = localities.id INNER JOIN places ON places.political_id = sublocalities.id AND places.political_type = 'Sublocality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"),
                self.states.joins("INNER JOIN counties ON states.id = counties.state_country_id AND counties.state_country_type = 'State' INNER JOIN localities ON counties.id = localities.administrative_area_id AND localities.administrative_area_type = 'County'  INNER JOIN sublocalities ON sublocalities.locality_id = localities.id INNER JOIN places ON places.political_id = sublocalities.id AND places.political_type = 'Sublocality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"),
                self.counties.joins("INNER JOIN places ON places.political_id = counties.id AND places.political_type = 'County' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"),
                self.counties.joins("INNER JOIN localities ON counties.id = localities.administrative_area_id AND localities.administrative_area_type = 'County' INNER JOIN places ON places.political_id = localities.id AND places.political_type = 'Locality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"), 
                self.counties.joins("INNER JOIN localities ON counties.id = localities.administrative_area_id AND localities.administrative_area_type = 'County' INNER JOIN sublocalities ON sublocalities.locality_id = localities.id INNER JOIN places ON places.political_id = sublocalities.id AND places.political_type = 'Sublocality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"),
                self.localities.joins("INNER JOIN places ON places.political_id = localities.id AND places.political_type = 'Locality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"),
                self.localities.joins("INNER JOIN sublocalities ON sublocalities.locality_id = localities.id INNER JOIN places ON places.political_id = sublocalities.id AND places.political_type = 'Sublocality' INNER JOIN posts ON posts.place_id = places.id").select("posts.id"))
  end
end
