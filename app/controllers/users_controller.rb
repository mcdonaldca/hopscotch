class UsersController < ApplicationController

  def index
    @users = User.all
  end

	def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:username, :email, :password, :password_confirmation, :first, :last, :phone, :bactrack_id)
    @user = User.new user_params
    if (@user.save)
      session[:user_id] = @user.id
      redirect_to bac_url
    else
      render action: 'new'
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    redirect_to users_url
  end
end
