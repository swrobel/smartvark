require 'net/http'
require 'rexml/document'
include REXML

class MapsController < ApplicationController
	def index
		@location = locateIp()

	end

	def locateIp
		#ip = "123.123.123.123";
		ip = request.remote_ip
		ips = ip.to_s
		url = "http://iplocationtools.com/ip_query.php?ip="+ips

		xml_data = Net::HTTP.get_response(URI.parse(url)).body

                xmldoc = REXML::Document.new(xml_data)

		# Now get the root element
		root = xmldoc.root
		city = ""
		regionName = ""
		countryName = ""

		# This will take country name...
		xmldoc.elements.each("Response/CountryName") {
		|e| countryName << e.text
	    }

		# Now get city name...
		xmldoc.elements.each("Response/City") {
   		|e| city << e.text
	    }

		# This will take regionName...
		xmldoc.elements.each("Response/RegionName") {
   		|e| regionName << e.text
	    }

     	ipLocation = city +", "+regionName+", "+countryName

	 return ipLocation
   end #end of method locateIp

end
