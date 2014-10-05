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
			bacobjects = JSON.parse(response)["objects"]
			mostrecentbac = nil
			mostrecenttimestamp = "1970-01-01T00:00:00" # start of epoch
			unless bacobjects.nil?
				bacobjects.each do |b|
					# 10261 should become the actual user's BACtrack id
					if b["person"] == "/internal_v1/users/10261/" && b["timestamp"] > mostrecenttimestamp
						mostrecentbac = b["bac_level"]
						mostrecenttimestamp = b["timestamp"]
					end
				end
			end
		end


		user = User.find(session[:user_id])
		user.latest_bac = mostrecentbac
		session[:timestamp] = mostrecenttimestamp

		# Find what their drunk emoji should be 
		user.drunk_emoji = get_drunk_emoji(mostrecentbac)

		# Find what their user interface should look like
		user.booze_level = get_booze_level(mostrecentbac)

		redirect_to choose_url
	end

	def setbac
		mostrecentbac = params[:bac]
		user.latest_bac = mostrecentbac
		session[:timestamp] = nil

		# Find what their drunk emoji should be 
		user.drunk_emoji = get_drunk_emoji(mostrecentbac)

		# Find what their user interface should look like
		user.booze_level = get_booze_level(mostrecentbac)

		redirect_to choose_url
	end

	def choose
	end

	def uber
		
		firstname = "Erin"
		lastname = "Hoffman"
		phone = "3174167556"
		#uberdestination = "229%20Commonwealth%20Ave%2C%20Boston%2C%20MA%2002116"
		@uberurl = "https://m.uber.com/sign-up?client_id=a-RTv0w8VfNjNR0oTUio1LXBDrjrBIUx"
		@uberurl += "&first_name="+firstname+"&last_name="+lastname+"&mobile_phone="+phone #+"&dropoff_address="+uberdestination
		@uberurl += "&dropoff_latitude=42.351248&dropoff_longitude=-71.082297"

	end

	def get_booze_level(bac)
		if bac == 0
			return 0
		elsif bac < 0.07
			return 1
		elsif bac < 0.13
			return 2
		else 
			return 3
		end
	end

	def get_drunk_emoji(bac)
		if bac == 0
			return "https://abs.twimg.com/emoji/v1/72x72/1f610.png"
		elsif bac < 0.02
			return "https://abs.twimg.com/emoji/v1/72x72/1f62f.png"
		elsif bac < 0.03
			return "https://abs.twimg.com/emoji/v1/72x72/263a.png"
		elsif bac < 0.04
			return "https://abs.twimg.com/emoji/v1/72x72/1f61a.png"
		elsif bac < 0.05
			return "https://abs.twimg.com/emoji/v1/72x72/1f601.png"
		elsif bac < 0.07
			return "https://abs.twimg.com/emoji/v1/72x72/1f61b.png"
		elsif bac < 0.09
			return "https://abs.twimg.com/emoji/v1/72x72/1f61c.png"
		elsif bac < 0.12
			return "https://abs.twimg.com/emoji/v1/72x72/1f61d.png"
		else
			return "https://abs.twimg.com/emoji/v1/72x72/1f632.png"
		end
	end
end
