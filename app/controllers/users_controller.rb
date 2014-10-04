class UsersController < ApplicationController

	def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:username, :email, :password, :password_confirmation, :first, :last, :phone)
    @user = User.new user_params
    if (@user.save)
      session[:user_id] = @user.id
      redirect_to bac_url
    else
      render action: 'new'
    end
  end
end
