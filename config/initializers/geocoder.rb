Geocoder::Configuration.lookup = :google

LA = Geocoder.search("Los Angeles, CA").first
