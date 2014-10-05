class RegistrationsController < ApplicationController

	def index
		@regs = Registration.all
	end

	def destroy
    @reg = Registration.find params[:id]
    @reg.destroy
    redirect_to registrations_url
  end
end
