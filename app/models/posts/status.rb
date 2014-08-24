class Posts::Status < ActiveRecord::Base
  has_many :posts, :foreign_key => :status_id
end