class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  private

  def get_logged_in_user
    id = session[:user_id]
    if id.nil?
      flash[:notice] = "You must log in first"
      redirect_to login_url
    else
      @user = User.find id
    end
  end
end
