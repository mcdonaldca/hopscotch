class AuthController < ApplicationController
  
  def login
  end

  def do_login
    username_from_form = params[:username]
    password_from_form = params[:password]
    @user = User.find_by_username(username_from_form)
    if (@user.nil?)
      flash[:notice] = "Unknown User"
      redirect_to login_url
    else
      if (@user.password == password_from_form)
        # User successfully logged in
        session[:user_id] = @user.id
        if @user.current_hop.nil?
          redirect_to new_hop_url
        else
          redirect_to bac_url
        end
      else
        flash[:notice] = "Incorrect Password"
        redirect_to login_url
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_url
  end

end
