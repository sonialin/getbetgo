module Identifiable
  extend ActiveSupport::Concern

  included do
    before_create :generate_identifier
  end

  protected

  def generate_identifier
    self.identifier = loop do
      random_identifier = SecureRandom.hex(5)
      break random_identifier unless self.class.exists?(identifier: random_identifier)
    end
  end
end