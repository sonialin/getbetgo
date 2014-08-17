class Post < ActiveRecord::Base
	belongs_to :user
	has_many :bets, :dependent => :destroy
  belongs_to :subcategory

  before_save :set_title_and_service

  acts_as_taggable
  acts_as_votable

  include PublicActivity::Common

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

	has_attached_file :image, :styles => { :big => '600', :medium => "200x150#", :thumb => "100x100#" }

	before_destroy :ensure_not_referenced_by_any_bet
  validates :user_id, presence: true
  validates :subcategory_id, presence: true
  validates :description, presence: true
  validates :tag_list, presence: true
  validates :location, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 5.00}
  validates :quantity, numericality: {:greater_than_or_equal_to => 1, :only_integer => true}
  validates :criteria, presence: true

  # after_initialize :default_values

  attr_reader :available_quantity

  def self.filter(params)
    posts = Post.all
    posts = posts.tagged_with(params[:tag]) if params[:tag]
    posts = posts.apply_category_filter(posts, params[:category]) if params[:category]
    posts = posts.apply_subcategory_filter(posts, params[:subcategory]) if params[:subcategory]
    posts = posts.apply_location_filter(params[:location]) if params[:location]
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

  def self.apply_location_filter(location)
    where(:location => location)
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
    self.bets.where(:status => ["Selected", "Submitted", "Funded"]).all.count
  end

  def beneficiaries
    self.bets.where(:status => 'Funded').count
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
    self.category.id
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

    def set_title_and_service
      self.service = 'Free' if self.service == nil
      self.title = 'I am giving $' + self.price.to_s + ' to ' + self.quantity.to_s + ' people who ' + self.criteria
    end
end
