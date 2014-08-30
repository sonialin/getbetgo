class Place < ActiveRecord::Base
  has_many :posts
  belongs_to :political, polymorphic: true
  validates :google_api_place_id, presence: true
  validates :political_id, presence: true
  validates :political_type, presence: true

  def self.create_entries(place_info)
    google_api_place_id = place_info[:id]
    country = place_info[:country]
    state = place_info[:state]
    county = place_info[:county]
    locality = place_info[:locality]
    sublocality = place_info[:sublocality]
    country = Country.find_or_create_by(country)
    create_country_hierarchy(country,state,county,locality,sublocality,google_api_place_id)
  end

  def self.create_country_hierarchy(country,state,county,locality,sublocality,google_api_place_id)
    if state
      state = country.states.find_or_create_by(state)
      create_state_hierarchy(state,county,locality,sublocality,google_api_place_id)
    elsif locality
      locality = country.localities.find_or_create_by(locality)
      create_locality_hierarchy(locality,sublocality,google_api_place_id)
    else
      country.create_place(:google_api_place_id => google_api_place_id) unless country.place
    end
  end

  def self.create_state_hierarchy(state,county,locality,sublocality,google_api_place_id)
    if county
      county = state.counties.find_or_create_by(county)
      create_county_hierarchy(county,locality,sublocality,google_api_place_id)
    elsif locality
      locality = state.localities.create(locality)
      create_locality_hierarchy(locality,sublocality,google_api_place_id)
    else
      state.create_place(:google_api_place_id => google_api_place_id) unless state.place
    end
  end

  def self.create_county_hierarchy(county,locality,sublocality,google_api_place_id)
    if locality
      locality = county.localities.find_or_create_by(locality)
      create_locality_hierarchy(locality,sublocality,google_api_place_id)
    else
      county.create_place(:google_api_place_id => google_api_place_id) unless county.place
    end
  end

  def self.create_locality_hierarchy(locality,sublocality,google_api_place_id)
    if sublocality
      sublocality = locality.sublocalities.create(sublocality)
      sublocality.create_place(:google_api_place_id => google_api_place_id) unless sublocality.place
    else
      locality.create_place(:google_api_place_id => google_api_place_id) unless locality.place
    end
  end

  def self.get_place_details(api_place_id)
    api_key = "AIzaSyCRTakbzqUehny4QI1eDS3HQxuoHXCpVIk"
    url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{api_place_id}&key=#{api_key}"
    uri = URI.parse(URI.encode(url))
    http = Net::HTTP.new(uri.host,uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    http.use_ssl = true
    result = JSON.parse(http.request(request).body)
    return nil unless result["status"] == "OK"
    place_info = {}
    result["result"]["address_components"].reverse.each do |type|
      if type["types"].include?("sublocality")
        place_info[:sublocality] = {:name => type["long_name"], :short_name => type["short_name"]}
      elsif type["types"].include?("locality")
        place_info[:locality] = {:name => type["long_name"], :short_name => type["short_name"]}
      elsif type["types"].include?("administrative_area_level_2")
        place_info[:county] = {:name => type["long_name"], :short_name => type["short_name"]}
      elsif type["types"].include?("administrative_area_level_1")
        place_info[:state] = {:name => type["long_name"], :short_name => type["short_name"]}
      elsif type["types"].include?("country")
        place_info[:country] = {:name => type["long_name"], :short_name => type["short_name"]}
      end
    end 
    place_info[:id] = result["result"]["place_id"]
    return place_info
  end
end
