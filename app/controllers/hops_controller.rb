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
			
		end
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
			end
		end
	end

	def current
		@user = User.find(session[:user_id])
		if @user.current_hop.nil?
			redirect_to new_hop_url
		end
		#@hop = Hops.find(@user.current_hop)
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
