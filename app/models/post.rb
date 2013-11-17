class Post < ActiveRecord::Base
	belongs_to :user
	has_many :bets

	before_destroy :ensure_not_referenced_by_any_bet
  # validates :user_id, presence: true

  attr_accessible :title, :description, :image_url, :price, :quantity
  attr_reader :available_quantity

  def available_quantity
  	quantity - bets.all.count
  end

  def bets_limit_reached?
    self.available_quantity <= 0
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
