class Bet < ActiveRecord::Base
	belongs_to :post
	belongs_to :user

  has_one :update

	validates :user_id, :uniqueness => { :scope => :post_id,
  :message => "Users may only make one bet per post." }

  validates :body, presence: true

  before_save :default_values

	# before_create :limit_check

	# def limit_check         
 #    if self.post.bets_limit_reached?
 #      errors.add :base, 'Bets limit reached.'           
 #      return false
 #    end       
 #    return true
 #  end 

  def select
    self.status = 'Selected'
    self.save!
  end

  def selected?
    self.status == "Selected"
  end

  def open?
    self.status == "Open"
  end

  def default_values
    self.status ||= 'Open'
  end
end
