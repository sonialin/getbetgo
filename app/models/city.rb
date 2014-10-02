class City < ActiveRecord::Base
  has_many :posts
  belongs_to :region, :autosave => true

  def tokenize
    return [] if self.full_name.blank?
    return [id: full_name, name: full_name]
  end

  def region_name
    self.region.name rescue nil
  end

  def country_name
    self.region.country.name rescue nil
  end

  def region_name=(name)
    self.region = Region.find_or_create_by(name: name)
  end

  def country_name=(name)
    self.region.country = Country.find_or_create_by(name: name)
  end
end
