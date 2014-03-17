class Bet < ActiveRecord::Base
	belongs_to :post
	belongs_to :user

	validates :user_id, :uniqueness => { :scope => :post_id,
  :message => "Users may only make one bet per post." }

  validates :body, presence: true

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
    save!
  end

  def selected?
    status == "Selected"
  end
end
