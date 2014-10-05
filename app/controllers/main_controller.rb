require 'net/http'
require 'time'

class MainController < ApplicationController

	before_filter :get_logged_in_user

	def bac
		user = User.find(session[:user_id])
		if user.current_hop.nil?
			redirect_to new_hop_url
		end
		@booze_level = user.booze_level
	end

	def get_bac
		user = User.find(session[:user_id])
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
					if b["person"] == "/internal_v1/users/" + user.bactrack_id + "/" && b["timestamp"] > mostrecenttimestamp
						mostrecentbac = b["bac_level"]
						mostrecenttimestamp = b["timestamp"]
					end
				end
			end
		end

		user = User.find(session[:user_id])
		user.latest_bac = mostrecentbac
		# BACtrack knows we're in EST but it thinks EST is 4 hours ahead of where it actually is
		mostrecenttimestamp = Time.parse(mostrecenttimestamp).advance(:hours => -4).strftime("%l:%M%p %B %e, %Y")
		session[:timestamp] = mostrecenttimestamp

		# Find what their drunk emoji should be 
		user.drunk_emoji = get_drunk_emoji(mostrecentbac)

		# Find what their user interface should look like
		user.booze_level = get_booze_level(mostrecentbac)

		user.save
		redirect_to choose_url
	end

	def admin
	end

	def set_bac
		@mostrecentbac = params[:bac].to_f
		@user = User.find(session[:user_id])
		@user.latest_bac = @mostrecentbac
		session[:timestamp] = nil

		# Find what their drunk emoji should be 
		@user.drunk_emoji = get_drunk_emoji(@mostrecentbac)

		# Find what their user interface should look like
		@user.booze_level = get_booze_level(@mostrecentbac)

		@user.save
		redirect_to choose_url
	end

	def choose
		@user = User.find(session[:user_id])
		@time = session[:timestamp]
	end

	def bars
		# TODO: get actual lat and long from user
		lat = "42.360986"
		long = "-71.096849"
		max_width = "100" #measured in px
		bars_request_string = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyBaaEBm7WetJlxmSCcShqvWSqttq63LTB8&location="+lat+","+long+"&rankby=distance&types=bar|night_club"
		bars_uri = URI.parse(URI.encode(bars_request_string))
		bars_https = Net::HTTP.new(bars_uri.host, bars_uri.port)
		bars_https.use_ssl = true
		bars_https.verify_mode = OpenSSL::SSL::VERIFY_NONE # this is NOT secure but Google's API is a free service and we aren't sharing real user data
		bars_request = Net::HTTP::Get.new(bars_uri.request_uri)
		bars_response = bars_https.request(bars_request).body
		results = JSON.parse(bars_response)["results"]
		@barlist = Array.new
		results.each do |r|
			barname = r["name"]
			baraddress = r["vicinity"]
			barlat = r["geometry"]["location"]["lat"]
			barlong = r["geometry"]["location"]["lng"]
			barrating = r["rating"]
			baricon = r["icon"]
			if baricon.include? "wine"
				bartype = "wine"
			else
				bartype = "bar"
			end
			@barlist << {:name => barname, :address => baraddress, :lat => barlat, :long => barlong, :rating => barrating, :type => bartype}
		end
	end

	def food
	end

	def uber
		user = User.find(session[:user_id])
		reg = Registration.find(user.current_hop)
		firstname = user.first
		lastname = user.last
		phone = user.phone

		#uberdestination = "229%20Commonwealth%20Ave%2C%20Boston%2C%20MA%2002116"
		@uberurl = "https://m.uber.com/sign-up?client_id=a-RTv0w8VfNjNR0oTUio1LXBDrjrBIUx"
		@uberurl += "&first_name="+firstname+"&last_name="+lastname+"&mobile_phone="+phone #+"&dropoff_address="+uberdestination
		@uberurl += "&dropoff_latitude=" + reg.final_destination_lat
		@uberurl += "&dropoff_longitude=" + reg.final_destination_long
	end

	def twilio
		# TODO: read this value from database
		phone = "+13174167556"
		account_sid = "AC698f80b23e2836098d6f58cf7498e4e0"
		auth_token = "01d2cb9b9bea47ef35df3b1d08c17eb7"
		@client = Twilio::REST::Client.new account_sid, auth_token
		message = @client.account.messages.create(
			:body => "This is a reminder text from Hopscotch",
			:to => phone,
			:from => "+13172520150")
		puts message.sid
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
		elsif bac < 0.13
			return "https://abs.twimg.com/emoji/v1/72x72/1f61d.png"
		else
			return "https://abs.twimg.com/emoji/v1/72x72/1f632.png"
		end
	end
end
