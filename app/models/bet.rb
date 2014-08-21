class Bet < ActiveRecord::Base
	belongs_to :post
	belongs_to :user

  has_many :replies
  has_one :fund
  has_one :order

  has_many :proofs, as: :documentable

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

  # def paid?
  #   !self.order.nil?
  # end

  # def select
  #   self.status = 'Selected'
  #   self.save!
  # end

  def selected?
    self.status == "Selected"
  end

  def open?
    self.status == "Open"
  end

  def submitted?
    self.status == "Submitted"
  end

  def awaiting_modification?
    self.status == "Awaiting Modification"
  end

  def modified?
    self.status == "Modified"
  end

  def credited?
    self.status == "Credited"
  end

  def funded?
    self.status == "Funded"
  end

  def default_values
    self.status ||= 'Open'
  end

  def self.order_by_updated_at_desc
    order("updated_at desc")
  end

  def self.filter_by_user(user_id)
    where(:user_id => user_id)
  end
end
