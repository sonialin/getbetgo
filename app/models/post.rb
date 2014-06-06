class Post < ActiveRecord::Base
	belongs_to :user
	has_many :bets, :dependent => :destroy
  has_many :updates

  before_create :set_title_and_service

  acts_as_taggable

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

	has_attached_file :image, :styles => { :big => '600', :medium => "200x150#", :thumb => "100x100#" }

	before_destroy :ensure_not_referenced_by_any_bet
  validates :user_id, presence: true
  validates :description, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :quantity, numericality: {:greater_than_or_equal_to => 1}

  # after_initialize :default_values

  # attr_accessible :title, :description, :image_url, :price, :quantity, :image
  attr_reader :available_quantity

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
      if self.service == nil
        self.service = 'Free'
      end
      self.title = 'I am giving $' + self.price.to_s + ' to ' + self.quantity.to_s + ' people for ' + self.service
    end
end
