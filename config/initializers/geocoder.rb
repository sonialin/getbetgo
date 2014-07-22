Geocoder.configure(
	:lookup => :bing,
	:key => ENV['BING_GEOCODE_KEY_LIVE'],
	:timeout => 15
)