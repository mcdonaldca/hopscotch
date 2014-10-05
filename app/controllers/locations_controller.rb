class LocationsController < ApplicationController
	def index
    @locations = Location.all
  end

  def destroy
    @location = Location.find params[:id]
    @location.destroy
    redirect_to locations_url
  end
end
