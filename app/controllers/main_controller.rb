class MainController < ApplicationController

	before_filter :get_logged_in_user

	def bac
	end

	def getbac
		# hard-coded latitude and longitude for now
		response = Net::HTTP.get_response(URI("http://mobile.bactrack.com/v1/readings/?lat_center=42.358675&lng_center=-71.096509&radius_meters=1000&format=json"))
		objects = JSON.parse(response)["objects"]
		
	end

	def choose
	end
end
