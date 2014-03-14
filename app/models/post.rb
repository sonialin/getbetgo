class Post < ActiveRecord::Base
	belongs_to :user
  has_one :order
	has_many :bets, :dependent => :destroy

	has_attached_file :image, :styles => { :big => '600', :medium => "250x200#", :thumb => "100x100#" }

	before_destroy :ensure_not_referenced_by_any_bet
  validates :user_id, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :quantity, numericality: {:greater_than_or_equal_to => 1}

  # attr_accessible :title, :description, :image_url, :price, :quantity, :image
  attr_reader :available_quantity

  def available_quantity
  	quantity - bets.all.count
  end

  # def bets_limit_reached?
  #   self.available_quantity <= 0 # make sure the quantity doesn't get below 0
  # end

  def total
    self.price * self.quantity
  end

  def paid?
    # if the payment has been made to make the post show up
    !self.order.nil?
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
end
