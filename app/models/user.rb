class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  include ActionView::Helpers::NumberHelper 
  include Identifiable

  acts_as_messageable
  acts_as_voter

  after_create :create_info_and_wallet

  has_one :user_info, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :bets, :dependent => :destroy
  has_many :replies
  has_many :modification_requests
  has_many :orders
  has_many :funds
  has_one :wallet, :dependent => :destroy
  has_one :paypal_recipient_account, :dependent => :destroy
  has_many :follower_relationships, class_name: 'Relationship', foreign_key: 'followed_id'
  has_many :followed_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :followers, through: :follower_relationships
  has_many :followeds, through: :followed_relationships
  has_many :sent_nominations, class_name: 'Nomination', foreign_key: 'sender_id'
  has_many :received_nominations, class_name: 'Nomination', foreign_key: 'receiver_id'

  validates_acceptance_of :terms, acceptance: true
  validates :name, presence: true
  validates :email, presence: true

  after_save :update_es_posts

  def update_es_posts
    self.posts.each {|post| Resque.enqueue(ElasticsearchApiWorker, post.id) }
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.new(name:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20]
                          )
        user.skip_confirmation!
        user.save
        user.user_info.avatar = URI.parse(auth.info.image) if auth.info.image?
        user.user_info.location = auth.info.location if auth.info.location?
        user.user_info.save
        return user
      end 
       
    end
  end

  def to_param 
    identifier
  end

  def following? user
    self.followeds.include?(user)
  end

  def create_info_and_wallet
    UserInfo.create(user_id: self.id)
    Wallet.create(user_id: self.id, credits: 0, coupons: 0) 
  end

  def follow user
    Relationship.create follower_id: self.id, followed_id: user.id
  end

  def kudos
    @kudos ||= self.posts.inject(0) {|sum, post| sum + post.votes_for.size}
  end

  def contributions
    self.posts.joins("INNER JOIN bets ON bets.post_id = posts.id INNER JOIN bets_statuses ON bets_statuses.id = bets.status_id").where("bets_statuses.name IN ('Selected', 'Submitted', 'Credited', 'Funded')").sum(:price).to_f
  end

  def credits
    self.bets.joins(:post).joins(:status).where("bets_statuses.name IN ('Submitted', 'Credited', 'Funded')").sum("posts.price").to_f
  end

  def applications_received
    @funds_for_applications_received = (self.posts.inject(0) {|sum, post| sum + post.bets.count * post.price}).to_f
  end

  def award_rate
    if self.applications_received == 0
      return 0
    else
      number_to_percentage((self.contributions / self.applications_received) * 100, precision: 0)
    end
  end

  def mailboxer_email(object)
    return email
  end

  def self.get_coordinates_from_ip(ip)
    ip = "103.226.207.46"
    return Rails.cache.read("ip_#{ip}") if Rails.cache.exist?("ip_#{ip}")
    ret = nil
    begin
      url = "http://www.geobytes.com/IpLocator.htm?GetLocation&template=php3.txt&IpAddress=#{ip}"
      uri = URI.parse(URI.encode(url))
      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      require 'nokogiri'
      doc = Nokogiri::HTML(http.request(request).body)
      lat = doc.xpath("//meta[@name='latitude']/@content").first.value.to_f
      long = doc.xpath("//meta[@name='longitude']/@content").first.value.to_f
      if (lat && long && lat != 0 && long != 0)
        ret = [lat,long]
      end
    rescue
    end
    Rails.cache.write("ip_#{ip}", ret)
    return ret
  end
end