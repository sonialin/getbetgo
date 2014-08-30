class Post < ActiveRecord::Base
	belongs_to :user
	has_many :bets, :dependent => :destroy
  belongs_to :subcategory
  belongs_to :status, :class_name => "::Posts::Status"
  belongs_to :place

  before_save :set_title

  acts_as_taggable
  acts_as_votable

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

	has_attached_file :image, :styles => { :big => '600', :medium => "200x150#", :thumb => "100x100#" }

	before_destroy :ensure_not_referenced_by_any_bet
  validates :user_id, presence: true
  validates :subcategory_id, presence: true
  validates :description, presence: true
  validates :tag_list, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 5.00}
  validates :quantity, numericality: {:greater_than_or_equal_to => 1, :only_integer => true}
  validates :criteria, presence: true
  validate :place_exist

  before_save :set_place_id

  # after_initialize :default_values
  attr_reader :available_quantity

  def place_exist
    @place_info = Place.get_place_details(self.api_place_id)
    self.errors.add(:base, "Select a place from dropdown") unless (Place.where(:google_api_place_id => self.api_place_id).first or @place_info)
  end

  def set_place_id
    place_row = Place.where(:google_api_place_id => self.api_place_id).first
    if place_row
      self.place_id = place_row.id
    else
      Place.create_entries(@place_info)
      self.place_id = Place.where(:google_api_place_id => self.api_place_id).first.id
    end
  end

  def location
    return nil unless self.place
    case self.place.political_type
      when 'Country'
        country = self.place.political
        return country.name
      when 'State'
        state = self.place.political
        country = state.country
        return  state.name + "," + country.name
      when 'County'
        county = self.place.political
        case county.state_country_type
          when 'Country'
            country = county.state_country
            return county.name + "," + country.name
          when 'State'
            state = county.state_country
            country = state.country
            return county.name + "," + state.short_name + "," + country.name
        end
      when 'Locality'
        locality = self.place.political
        case locality.administrative_area_type
          when 'Country'
            country = locality.administrative_area
            return locality.name + "," + country.name 
          when 'County'
            county = locality.administrative_area
            case county.state_country_type
              when 'Country'
                country = county.state_country
                return locality.name + "," + county.short_name + "," + country.name
              when 'State'
                state = county.state_country
                country = state.country
                return locality.name + "," + state.short_name + "," + country.name
            end       
          when 'State'
            country = state.country    
            return locality.name + "," + state.short_name + "," + country.name  
        end  
      when 'Sublocality'
        sublocality = self.place.political
        locality = sublocality.locality
        case locality.administrative_area_type
          when 'Country'
            country = locality.administrative_area
            return sublocality.name + "," + locality.short_name + "," + country.name 
          when 'County'
            county = locality.administrative_area
            case county.state_country_type
              when 'Country'
                country = county.state_country
                return sublocality.name + "," + locality.short_name + "," + county.short_name + "," + country.name
              when 'State'
                state = county.state_country
                country = state.country
                return sublocality.name + "," + locality.short_name + "," + state.short_name + "," + country.name
            end            
          when 'State'
            state = locality.administrative_area
            country = state.country    
            return sublocality.name + "," + locality.short_name + "," + state.short_name + "," + country.name  
        end  
    end
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
    politicals = location.split(',').reverse
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

  def slug_candidates
    [
      [:service, :category, :tag_list],
      [:service, :category, :tag_list, :location]
    ]
  end

  def available_quantity
  	quantity - bets.all.count
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

  def google_api_place_id
    self.place.google_api_place_id rescue nil
  end

  # Gets the object's singleton class. Backported from Rails 2.3.8 to support older versions of Rails.
  def singleton_class
    class << self
      self
    end
  end   

  def set_api_place_id api_place_id
    singleton_class.send(:attr_accessor, "api_place_id")
    send("api_place_id" + "=", api_place_id)
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
      self.title = 'I am giving $' + self.price.to_s + ' to ' + self.quantity.to_s + ' people who ' + self.criteria
    end
end
