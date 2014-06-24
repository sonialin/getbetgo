class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  acts_as_messageable

  has_one :user_info, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :bets, :dependent => :destroy
  has_many :orders
  has_many :updates
  has_many :funds
  has_one :paypal_recipient_account
  has_many :follower_relationships, class_name: 'Relationship', foreign_key: 'followed_id'
  has_many :followed_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :followers, through: :follower_relationships
  has_many :followeds, through: :followed_relationships

  has_attached_file :avatar, :styles => { :medium => "200x200#", :thumb => "60x60#" }, :default_url => "http://placehold.it/100x100"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :name, presence: true

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            avatar: auth.info.image,
                            password:Devise.friendly_token[0,20]
                          )
      end
       
    end
  end

  def following? user
    self.followeds.include?(user)
  end

  def follow user
    Relationship.create follower_id: self.id, followed_id: user.id
  end

  def mailboxer_email(object)
    return email
  end
end