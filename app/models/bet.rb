class Bet < ActiveRecord::Base
	belongs_to :post
	belongs_to :user
  belongs_to :status, :class_name => "::Bets::Status"

  has_many :replies
  has_one :fund
  has_one :order

  has_many :proofs, as: :documentable

	validates :user_id, :uniqueness => { :scope => :post_id,
  :message => "The user may submit only one application to one fund." }

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

  after_save :update_es_post

  def update_es_post
    Resque.enqueue(ElasticsearchApiWorker, self.post_id)
  end

  def status
    ::Bets::Status.find(self.status_id).name rescue nil
  end

  def status=(status_name)
    self.status_id = ::Bets::Status.find_by_name(status_name).id
  end

  def change_to_credited
    self.status = "Credited"
    self.save
  end

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
    find_by_user_id(user_id)
  end
end
