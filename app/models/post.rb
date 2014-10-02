class Post < ActiveRecord::Base
	belongs_to :user
	has_many :bets, :dependent => :destroy
  has_many :orders
  has_many :nominations
  belongs_to :subcategory
  belongs_to :status, :class_name => "::Posts::Status"
  belongs_to :city, :autosave => true

  before_save :set_title

  acts_as_taggable
  acts_as_votable
  is_impressionable

  extend FriendlyId
  friendly_id :custom_slug_name, use: :slugged

	has_attached_file :image, :styles => { :big => '600', :medium => "200x150#", :thumb => "100x100#" }

	before_destroy :ensure_not_referenced_by_any_bet
  validates :user_id, presence: true
  validates :subcategory_id, presence: true
  validates :description, presence: true
  validates :tag_list, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 5.00}
  validates :quantity, numericality: {:greater_than_or_equal_to => 1, :only_integer => true}
  validates :criteria, presence: true
  accepts_nested_attributes_for :city

  after_save :update_es_post
  before_destroy :delete_es_post

  def update_es_post
    Resque.enqueue(ElasticsearchApiWorker, self.id)
  end

  def delete_es_post
    Posts::ElasticsearchApi.new.delete_post(self.id)
  end

  def autosave_associated_records_for_city
    if city.name.blank? or city.full_name.blank? or city.latitude.blank? or city.longitude.blank?
      self.errors.add(:base, "Location can't be blank")
      return false
    else
      if existing_city = City.find_by_full_name(city.full_name)
        self.city = existing_city
      else
        self.city.save!
        self.city_id = self.city.id
      end
    end
  end

  #def autosave_associated_records_for_place
  #  if existing_place = Place.where(:google_api_place_id => place.google_api_place_id).first
  #    self.place = existing_place
  #  else
  #    place_info = Place.get_place_details(place.google_api_place_id)
  #    if place_info
  #      Place.create_entries(place_info)
  #      self.place = Place.where(:google_api_place_id => place.google_api_place_id).first
  #    else
  #      self.errors.add(:base, "Location can't be blank")
  #      return false
  #    end
  #  end
  #end

  # after_initialize :default_values
  attr_reader :available_quantity

  def self.search(query)
    where("title like ? or description like ?", "%#{query}%", "%#{query}%") 
  end

  def location
    self.city.full_name rescue nil
  end

  def status
    ::Posts::Status.find(self.status_id).name rescue nil
  end

  def status=(status_name)
    if status_name
      self.status_id = ::Posts::Status.find_by_name(status_name).id
    else
      self.status_id = nil
    end
  end

  def self.filter(params)
    posts = Post.all
    posts = posts.tagged_with(params[:tag]) if params[:tag]
    posts = posts.apply_category_filter(posts, params[:category]) if params[:category]
    posts = posts.apply_subcategory_filter(posts, params[:subcategory]) if params[:subcategory]
    posts = posts.apply_location_filter(posts, params[:location]) if params[:location]
    return posts
  end

  def self.apply_category_filter(posts, category_name)
    category = Category.find_by_name(category_name)
    posts.filter_by_subcategory_ids(category.subcategories.pluck(:id))
  end

  def self.apply_subcategory_filter(posts, subcategory_name)
    subcategory = Subcategory.find_by_name(subcategory_name)
    posts.where(:subcategory_id => subcategory.id)
  end

  def self.apply_location_filter(posts, location)
    politicals = location.split(', ').reverse
    begin
      country = Country.find_by_name(politicals[0])
      return country.posts if politicals.size == 1
      state = country.states.where("name = ? or short_name = ?",politicals[1],politicals[1]).first
      county = country.counties.where("name = ? or short_name = ?",politicals[1],politicals[1]).first
      if state
        return state.posts if politicals.size == 2
        county = state.counties.find_by_name(politicals[2]) if politicals.size == 3
        if county
          return county.posts
        else
          locality = state.localities.where("name = ? or short_name = ?",politicals[2],politicals[2]).first
          locality ||= Locality.joins("INNER JOIN counties ON counties.id = localities.administrative_area_id AND localities.administrative_area_type = 'County' INNER JOIN states ON states.id = counties.state_country_id AND counties.state_country_type = 'State'").where("states.id = ? AND (localities.name = ? or localities.short_name = ?)",state.id,politicals[2],politicals[2]).first
          return locality.posts if politicals.size == 3
          sublocality = locality.sublocalities.find_by_name(politicals[3])
          return sublocality.posts if politicals.size == 4
        end
      elsif county
        return county.posts if politicals.size == 2
        locality = county.localities.where("name = ? or short_name = ?",politicals[2],politicals[2]).first
        return locality.posts if politicals.size == 3
        sublocality = locality.sublocalities.find_by_name(politicals[3])
        return sublocality.posts if politicals.size == 4     
      else
        locality = country.localities.where("name = ? or short_name = ?",politicals[1],politicals[1]).first
        return locality.posts if politicals.size == 2
        sublocality = locality.sublocalities.find_by_name(politicals[3])
        return sublocality.posts if politicals.size == 3
      end
    rescue
    end
    return Post.where(:id => [])
  end

  def custom_slug_name
    "#{self.user.identifier} #{self.subcategory.name} #{self.criteria}"
  end

  def available_quantity
  	self.quantity - self.bets.all.count
  end

  # def bets_limit_reached?
  #   self.available_quantity <= 0 # make sure the quantity doesn't get below 0
  # end

  def total
    self.price * self.quantity
  end

  def bets_past_selection
    self.bets.joins(:status).where("bets_statuses.name IN ('Selected', 'Submitted', 'Awaiting Modification', 'Modified', 'Credited', 'Funded')")
  end

  def given_out_fund
    self.bets_past_selection.count * self.price.to_f
  end

  def not_selected_bets
    self.bets.where(:status_id => 1)
  end

  def beneficiaries
    self.bets.joins(:status).where("bets_statuses.name IN ('Submitted', 'Credited', 'Funded')").count
  end

  def claimed_fund
    self.beneficiaries * self.price.to_f
  end

  def percentage_claimed
    self.claimed_fund / self.total * 100
  end

  def default_values
    if !self.order.nil?
      self.status = 'Paid'
    else
      self.status ||= 'Drafted'
    end
  end

  def self.filter_by_subcategory_ids(subcategory_ids)
    where(:subcategory_id => subcategory_ids)
  end

  def category
    self.subcategory.category
  end

  def category_id
    self.category.id rescue nil
  end

  def tags_tokenize
    response = []
    self.tag_list.each do |tag|
      if db_tag = ActsAsTaggableOn::Tag.where("LOWER(name) = ?",tag.downcase).first
        response.push({:id => db_tag.id, :name => tag.downcase})
      else
        response.push({:id => tag.downcase, :name => tag.downcase})
      end
    end
    return response
  end

  private
 
    # ensure that there are no bets referencing this post
    def ensure_not_referenced_by_any_bet
      if bets.empty?
        return true
      else
        errors.add(:base, 'Bets present')
        return false
      end
    end

    def set_title
      self.title = 'I am offering $' + self.price.to_s + ' to ' + self.quantity.to_s + ' people who want to ' + self.criteria
    end
end
