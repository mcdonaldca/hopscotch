class HopsController < ApplicationController

	before_filter :get_logged_in_user

	def index
		@hops = Hop.all
	end

	def new
	end

	def create
		@hop = Hop.new
		handle = params[:handle]

		if handle == "wing"
			@hop.planned = false
			@hop.code = (0...4).map { ('a'..'z').to_a[rand(26)] }.join
			@hop.save

			@registration = Registration.new
			@registration.user_id = session[:user_id]
			@registration.hop_id = @hop.id
			@registration.active = true
			@registration.save
			#session[:reg_id] = @registration.id

			@user = User.find(session[:user_id])
			@user.current_hop = @registration.id
			
			if @user.save 
				redirect_to destination_url
			else
				render action "new"
			end
		elsif handle == "plan"
			@hop.planned = true
			@hop.code = (0...4).map { ('a'..'z').to_a[rand(26)] }.join
			@hop.save

			@registration = Registration.new
			@registration.user_id = session[:user_id]
			@registration.hop_id = @hop.id
			@registration.active = true
			@registration.save
			#session[:reg_id] = @registration.id

			@user = User.find(session[:user_id])
			@user.current_hop = @registration.id
			
			if @user.save 
				redirect_to destination_url
			else
				render action "new"
			end
		end
	end

	def pick_locations
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

	def set_locations
		@places = params[:locations]
	end

	def plan_created
		@params = params
		@count = params["count"].to_i

		for i in 0..@count
		  @loc = Location.new
			@loc.name = params[i.to_s + "-name"].to_s
			@loc.time = params[i.to_s].to_s
			@loc.registration_id = User.find(session[:user_id]).current_hop
			@loc.save
			##SLEEPSCOTCH HERE
			plan_uri = URI.parse("http://sleepscotch-hackmit.herokuapp.com/receive/10:01am/Harpers/+3174167556")
			Net::HTTP.new(plan_uri.host, plan_uri.port)
		end

		redirect_to current_hop_url
	end

	def destination
		@user = User.find(session[:user_id])
		if @user.current_hop.nil?
			redirect_to new_hop_url
		end
		@reg_id = @user.current_hop
	end

	def save_destination
		latitude = params[:latitude]
		longitude = params[:latitude]
		@user = User.find(session[:user_id])

		reg = Registration.find(@user.current_hop)
		reg.final_destination_lat = latitude
		reg.final_destination_long = longitude
		if reg.save
			if reg.hop.planned == false
				redirect_to bac_url
			elsif reg.hop.planned == true
				redirect_to pick_locations_url
			end
		end
	end

	def current
		@user = User.find(session[:user_id])
		if @user.current_hop.nil?
			redirect_to new_hop_url
		end
		@reg = Registration.find(@user.current_hop)
	end

	def leave
		if User.find(session[:user_id]).current_hop.nil?
			redirect_to new_hop_url
		end
		@check = User.find(session[:user_id]).current_hop
	end

	def uber_end 
		@user = User.find(session[:user_id])
		if @user.current_hop.nil?
			redirect_to new_hop_url
		end
		@reg = Registration.find(35)
		firstname = @user.first
		lastname = @user.last
		phone = @user.phone

		uberdestination = "229%20Commonwealth%20Ave%2C%20Boston%2C%20MA%2002116"
		@uberurl = "https://m.uber.com/sign-up?client_id=a-RTv0w8VfNjNR0oTUio1LXBDrjrBIUx"
		@uberurl += "&first_name="+firstname+"&last_name="+lastname+"&mobile_phone="+phone #+"&dropoff_address="+uberdestination
		@uberurl += "&dropoff_latitude=" + @reg.final_destination_lat
		@uberurl += "&dropoff_longitude=" + @reg.final_destination_long

		user = User.find(session[:user_id])
		reg = Registration.find(user.current_hop)
		reg.active = false
		reg.save
		user.current_hop = nil
		user.save
		redirect_to(@uberurl)
	end

	def end_hop
		user = User.find(session[:user_id])
		unless user.current_hop.nil?
			reg = Registration.find(user.current_hop)
			reg.active = false
			reg.save
			user.current_hop = nil
			user.save
		end
		redirect_to new_hop_url
	end

	def destroy
    @hop = Hop.find params[:id]
    user = User.find(session[:user_id])

    if user.current_hop == @hop.id
    	user.current_hop = nil
    	user.save
    end


    @hop.destroy
    redirect_to hops_url
  end
end
