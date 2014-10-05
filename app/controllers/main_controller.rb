require 'net/http'

class MainController < ApplicationController

	before_filter :get_logged_in_user

	def bac
		@booze_level = User.find(session[:user_id]).booze_level
	end

	def getbac
		# hard-coded latitude and longitude for now
		response = Net::HTTP.get_response(URI("http://mobile.bactrack.com/v1/readings/?lat_center=42.358675&lng_center=-71.096509&radius_meters=1000&format=json")).body
		# a few times it returned a 400 Bad Request message instead of content, so this checks for that
		unless response.include? "Bad Request"
			@bacobjects = JSON.parse(response)["objects"]
			@mostrecentbac = nil
			@mostrecenttimestamp = "1970-01-01T00:00:00" # start of epoch
			unless @bacobjects.nil?
				@bacobjects.each do |b|
					# 10261 should become the actual user's BACtrack id
					if b["person"] == "/internal_v1/users/10261/" && b["timestamp"] > @mostrecenttimestamp
						@mostrecentbac = b["bac_level"]
						@mostrecenttimestamp = b["timestamp"]
					end
				end
			end
		end
	end

	def choose
	end
end
