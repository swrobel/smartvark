#Geocoder::Configuration.lookup = :google
#Geocoder::Configuration.api_key = ENV['GOOGLE_GEOCODER_KEY']

Geocoder::Configuration.lookup = :yahoo
Geocoder::Configuration.api_key = ENV['YAHOO_GEOCODER_KEY']

#Geocoder::Configuration.lookup = :bing
#Geocoder::Configuration.api_key = ENV['BING_GEOCODER_KEY']

LA = Geocoder.search("Los Angeles, CA").first