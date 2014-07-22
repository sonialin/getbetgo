Geocoder.configure(
	:lookup => :bing,
	:key => ENV['BING_GEOCODE_KEY_LIVE'],
	:cache=> Rails.cache,
	:timeout => 15
)