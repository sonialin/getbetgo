class Bets::Status < ActiveRecord::Base
  has_many :bets, :foreign_key => :status_id
end